import { SafeAreaView, StyleSheet, Text, TouchableOpacity, View, Modal, Alert } from 'react-native'
import React, { useEffect, useState } from 'react'
import { useFocusEffect } from '@react-navigation/native';
import { useCallback } from 'react';
import { useAuth } from '../../context/auth';
import api_client from '../../config/api_client';
import { FlatList } from 'react-native-gesture-handler';
import moment from 'moment';
import { ActivityIndicator } from 'react-native';

const Calendars = () => {
  const { user } = useAuth();
  const [calendars, setCalendars] = useState([])
  const [modalVisible, setModalVisible] = useState(false);
  const [selectedCalendar, setSelectedCalendar] = useState(null);
  const [events, setEvents] = useState([])
  const [loading, setLoading] = useState(true)

  useFocusEffect(
    useCallback(() => {
      getCalendars()
    }, [])
  );

  useEffect(() => {
    if (selectedCalendar) {
      getEvents()
    }
  }, [selectedCalendar])

  const getCalendars = async () => {
    await api_client.get(`/calendars`)
      .then(async ({ data }) => {
        setCalendars(data)
      }).catch(e => console.log(e))
    setLoading(false)
  }

  const getEvents = async () => {
    setLoading(true)
    await api_client.get(`/events?calendar_id=${selectedCalendar.id}`)
      .then(async ({ data }) => {
        if (data) {
          setEvents(data)
          setModalVisible(true)
        }
        else {
          Alert.alert("No events to import!")
        }

      }).catch(e => console.log(e))
    setLoading(false)
  }

  const formatDates = (data, type) => {
    let formattedDate
    switch (type) {
      case 'date':
        formattedDate = `${moment(data).format("DD/MM/YYYY")}`
        break;
      case 'dateTime':
        formattedDate = moment(data).format("DD/MM/YYYY hh:mm a")
        break;
    }

    return formattedDate
  }

  const importCalendarAndEvents = () => {
    setLoading(true)
    api_client.post('/import_calendars_and_events', { calendar_ids: [selectedCalendar.id] })
      .then(res => {
        setModalVisible(false)
        setSelectedCalendar(false)
        Alert.alert("Calendar and events imported successfully!")
      })
      .catch(err => console.error(err))
    setLoading(false)
  }

  const closeModal = () => {
    setModalVisible(false)
    setSelectedCalendar(null)
  }

  const isAllDayEvent = (event) => event ?
    <View style={styles.allDayEventBadge}>
      <Text style={styles.allDayEventText}>All day</Text>
    </View> : ''

  const ModalComponent = () => {
    return (
      <Modal
        animationType="slide"
        transparent={true}
        visible={modalVisible}
        onRequestClose={() => {
          Alert.alert("Modal has been closed.");
          setModalVisible(!modalVisible);
        }}
      >
        <SafeAreaView style={styles.centeredView}>
          <View style={styles.modalView}>
            <View style={{ flex: 1, paddingHorizontal: 10 }}>
              <FlatList
                data={events}
                showsVerticalScrollIndicator={false}
                renderItem={({ item }) => (
                  <View style={styles.eventItem}>
                    <View style={styles.eventItemTitleContainer}>
                      <Text style={styles.eventItemTitle}>{item.summary}</Text>
                      {isAllDayEvent(item?.start?.date)}
                    </View>
                    <View style={styles.eventItemDetails}>
                      <Text style={{ color: "#767577" }}>Starts at: </Text>
                      <Text style={{ color: "#81b0ff" }}>{item.start.date ? formatDates(item.start.date, 'date') : formatDates(item.start.date_time || item.start.dateTime, 'dateTime')}</Text>
                    </View>
                    <View style={styles.eventItemDetails}>
                      <Text style={{ color: "#767577" }}>Finishes at: </Text>
                      <Text style={{ color: "red" }}>{item.end.date ? formatDates(item.end.date, 'date') : formatDates(item.end.dateTime || item.end.date_time, 'dateTime')}</Text>
                    </View>

                  </View>
                )}
              />
            </View>
            <View style={styles.divider} />
            <View style={{ padding: 10 }}>

              <Text style={styles.modalText}>Do you want to import these events?</Text>
              <View style={{ flexDirection: 'column' }}>
                <TouchableOpacity
                  style={[styles.button, styles.buttonConfirm]}
                  onPress={() => importCalendarAndEvents()}
                >
                  <Text style={styles.textStyle}>Yes</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={{ paddingVertical: 10, alignItems: 'center' }}
                  onPress={() => closeModal()}
                >
                  <Text>No</Text>
                </TouchableOpacity>

              </View>
            </View>
          </View>
        </SafeAreaView>
      </Modal>
    )
  }

  const Item = ({ item, onPress }) => (
    <TouchableOpacity onPress={onPress} style={styles.item}>
      <Text style={styles.title}>{user.email === item.summary ? `Personal Calendar (${item.summary})` : item.summary}</Text>
      <Text style={styles.description}>{item.description}</Text>
    </TouchableOpacity>
  );

  const renderItem = ({ item }) => {

    return (
      <Item
        item={item}
        onPress={() => setSelectedCalendar(item)}
      />
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      {loading ?
        <View style={styles.loading}>
          <ActivityIndicator />
        </View>
        :
        <>
          {calendars && calendars.length > 0 ?
            <FlatList
              data={calendars}
              renderItem={renderItem}
              keyExtractor={item => item.id}
            />
            :
            <View style={styles.noCalendarsMessage}>
              <Text>No calendars to show.</Text>
            </View>

          }
          {modalVisible && selectedCalendar && <ModalComponent item={selectedCalendar} setModalVisible={setModalVisible} />}
        </>

      }
    </SafeAreaView>
  )
}

export default Calendars

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginTop: 10,
  },
  item: {
    padding: 10,
    marginVertical: 5,
    marginHorizontal: 8,
    height: 90,
    borderRadius: 16,
    backgroundColor: '#fff',
    justifyContent: 'center',
    shadowColor: "#000",
    shadowOffset: {
      width: 0,
      height: 1,
    },
    shadowOpacity: 0.22,
    shadowRadius: 2,
    elevation: 3
  },
  title: {
    fontSize: 18,
    textAlign: 'center',
    fontWeight: 600,
  },
  description: {
    fontSize: 14,
    textAlign: 'center',
    color: '#767577'
  },
  centeredView: {
    flex: 1,
  },
  modalView: {
    margin: 10,
    flex: 1,
    paddingVertical: 10,
    backgroundColor: "white",
    borderRadius: 10,
    shadowColor: "#000",
    shadowOffset: {
      width: 0,
      height: 2
    },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5
  },
  button: {
    borderRadius: 8,
    padding: 10,
    elevation: 2,
    marginHorizontal: 20
  },
  buttonDelete: {
    backgroundColor: "red",
  },
  buttonConfirm: {
    backgroundColor: "#2196F3",
  },
  buttonToAdd: {
    backgroundColor: "#2196F3",
    padding: 5,
    borderWidth: 1,
    borderColor: '#4286f4',
    borderRadius: 4
  },
  buttonToReturn: {
    backgroundColor: "red",
    padding: 5,
    borderWidth: 1,
    borderColor: 'red',
    borderRadius: 4
  },
  textStyle: {
    color: "white",
    fontWeight: "bold",
    textAlign: "center"
  },
  modalText: {
    marginBottom: 15,
    textAlign: "center"
  },
  eventItem: {
    borderBottomWidth: 1,
    borderBottomColor: "#eee",
    padding: 15
  },
  allDayEventBadge: {
    backgroundColor: "#4286f4",
    padding: 4,
    height: 25,
    justifyContent: 'center',
    borderRadius: 25
  },
  allDayEventText: {
    fontSize: 12,
    color: "#fff"
  },
  eventItemTitleContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 5
  },
  eventItemTitle: {
    fontWeight: 600,
    fontSize: 15,
    maxWidth: "85%"
  },
  eventItemDetails: {
    flexDirection: 'row',
    justifyContent: 'space-between'
  },
  divider: {
    borderTopWidth: 1,
    borderColor: "#eee"
  },
  noCalendarsMessage: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  loading: {
    flex: 1, 
    alignItems: 'center', 
    justifyContent: 'center'
  }

});