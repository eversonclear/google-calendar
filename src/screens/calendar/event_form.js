import { Alert, Platform, StyleSheet, Switch, Text, TextInput, View } from 'react-native'
import React, { useEffect } from 'react'
import { SafeAreaView } from 'react-native-safe-area-context';
import moment from 'moment';
import ReturnButton from '../../components/shared/return_button';
import FeatherIcon from 'react-native-vector-icons/Feather'
import { TouchableOpacity } from 'react-native-gesture-handler';
import { useState } from 'react';
import api_client from '../../config/api_client';
import DateTimePickerModal from "react-native-modal-datetime-picker";
import { useNavigation } from '@react-navigation/native';
import { useAuth } from '../../context/auth';

const EventForm = ({ route }) => {
  const { user } = useAuth()
  const { event, date } = route?.params
  const [summary, setSummary] = useState(event?.summary || '')
  const [description, setDescription] = useState(event?.description || '')
  const [allDay, setAllDay] = useState(event?.is_all_day || false)
  const [startsAt, setStartsAt] = useState(event?.starts_at || date)
  const [finishesAt, setFinishesAt] = useState(event?.finishes_at || date)
  const [dateType, setDateType] = useState(null)
  const [isDatePickerVisible, setDatePickerVisibility] = useState(false);
  const navigation = useNavigation()

  useEffect(() => {
    if (dateType) showDatePicker()
  }, [dateType])

  const showDatePicker = () => {
    setDatePickerVisibility(true);
  };

  const hideDatePicker = () => {
    setDateType(null)
    setDatePickerVisibility(false);
  };

  const handleConfirm = (date) => {
    if (dateType === 'starts_at') {
      setStartsAt(date)
    } else {
      setFinishesAt(date)
    }
    hideDatePicker();
  };

  const toggleSwitch = () => setAllDay(previousState => !previousState);

  const startsAtIsBeforeFinishesAt = () => new Date(finishesAt) > new Date(startsAt)

  const updateOrCreate = () => {
    if (!startsAtIsBeforeFinishesAt() && !allDay) {
      Alert.alert("Your event needs to start before your finish date")
      return;
    }

    let newEvent = {
      summary,
      description,
      is_all_day: allDay,
      starts_at: startsAt,
      finishes_at: finishesAt,
      organizer_email: event?.organizer_email || user.email
    }

    return event?.id ? updateEvent(newEvent) : createEvent(newEvent)
  }

  const updateEvent = (newEvent) => {
    api_client.put(`/events/${event.id}`, { event: newEvent })
      .then((response) => {
        let date = moment.utc(newEvent.starts_at).toISOString()
        navigation.navigate("Calendar", { date })
      })
      .catch(err => console.error(err))
  }

  const createEvent = (newEvent) => {
    api_client.post(`/events`, { event: newEvent })
      .then((response) => {
        let date = moment.utc(response.data.starts_at).toISOString()
        navigation.navigate("Calendar", { date })
      })
      .catch(err => console.error(err))
  }

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <View style={styles.header}>
        <ReturnButton />
        <View style={{ flexDirection: 'row' }} >
          <TouchableOpacity onPress={updateOrCreate} style={styles.saveButton}>
            <Text style={{ color: "#fff", fontSize: 16 }}>Save</Text>
          </TouchableOpacity>
        </View>
      </View>

      <View style={styles.summaryInput}>
        <TextInput style={{ fontSize: 26 }} multiline={true} value={summary} placeholder="Add summary" onChangeText={(text) => setSummary(text)} />
      </View>
      <View style={styles.selectDates}>

        <View style={styles.selectDatesContent}>
          <Text style={{ fontSize: 18 }}>All-day</Text>
          <Switch
            trackColor={{ false: '#767577', true: '#81b0ff' }}
            thumbColor={allDay ? '#4286f4' : '#f4f3f4'}
            ios_backgroundColor="#3e3e3e"
            onValueChange={toggleSwitch}
            value={allDay}
            style={{ transform: [{ scaleX: Platform.OS == "ios" ? .7 : .9 }, { scaleY: Platform.OS == "ios" ? .7 : .9 }] }}
          />
        </View>
      </View>

      <TouchableOpacity disabled={allDay} onPress={() => setDateType('starts_at')} style={styles.selectStartsAt}>
        <Text style={{ fontSize: 16, color: allDay ? "#767577" : "#000" }}>
          {moment.utc(startsAt).format("ddd, MMM DD, YYYY")}
        </Text>
        <Text style={{ fontSize: 16, color: allDay ? "#767577" : "#000" }}>
          {moment(startsAt).format("hh:mm A")}
        </Text>
      </TouchableOpacity>

      <TouchableOpacity disabled={allDay} onPress={() => setDateType('finishes_at')} style={styles.selectFinishesAt}>
        <Text style={{ fontSize: 16, color: allDay ? "#767577" : "#000" }}>
          {moment.utc(finishesAt).format("ddd, MMM DD, YYYY")}
        </Text>
        <Text style={{ fontSize: 16, color: allDay ? "#767577" : "#000" }}>
          {moment(finishesAt).format("hh:mm A")}
        </Text>
      </TouchableOpacity>

      <View style={styles.addDescription}>
        <FeatherIcon name="align-left" size={24} style={{ paddingLeft: 15 }} />
        <View style={{ paddingHorizontal: 10, }}>
          <TextInput style={{ fontSize: 16 }} multiline={true} value={description} placeholder="Add description" placeholderTextColor="#000" onChangeText={(text) => setDescription(text)} />
        </View>
      </View>

      <DateTimePickerModal
        isVisible={isDatePickerVisible}
        mode="datetime"
        onConfirm={handleConfirm}
        onCancel={hideDatePicker}
        date={new Date(event?.starts_at || date)}
      />
    </SafeAreaView>
  )
}

export default EventForm

const styles = StyleSheet.create({
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginHorizontal: 10,
    marginTop: 10
  },
  saveButton: {
    marginRight: 10,
    backgroundColor: "#4286f4",
    padding: 10,
    borderRadius: 30
  },
  summaryInput: {
    paddingHorizontal: 50,
    marginTop: 20,
    marginBottom: 10,
    borderBottomWidth: 1,
    borderBottomColor: "#eee",
    paddingBottom: 20,
    width: '100%'
  },
  selectDates: {
    paddingLeft: 50,
    paddingRight: 10,
    marginTop: 20,
    marginBottom: 10
  },
  selectDatesContent: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center'
  },
  selectStartsAt: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingRight: 20,
    paddingLeft: 50,
    marginTop: 20,
    marginBottom: 10
  },
  selectFinishesAt: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingRight: 20,
    paddingLeft: 50,
    marginTop: 20,
    borderBottomWidth: 1,
    borderBottomColor: "#eee",
    paddingBottom: 20
  },
  addDescription: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 20,
    borderBottomWidth: 1,
    borderBottomColor: "#eee",
    width: "90%",
  }
})