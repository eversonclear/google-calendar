import { StyleSheet, Text, TouchableOpacity, View, ScrollView } from 'react-native'
import React, { useEffect, useState } from 'react'
import CalendarStrip from 'react-native-calendar-strip'
import moment from 'moment'
import api_client from '../../config/api_client'
import { useAuth } from '../../context/auth'
import { useNavigation } from '@react-navigation/native'
import FeatherIcon from 'react-native-vector-icons/Feather'

const Calendar = ({ route }) => {
  const [selectedDate, setSelectedDate] = useState(moment.utc().toISOString());
  const [events, setEvents] = useState([]);
  const [markedDates, setMarkedDates] = useState([]);
  const navigator = useNavigation()

  useEffect(() => {
    eventsFromToday(route?.params?.date)
  }, [route])

  const eventsFromToday = (date = new Date()) => {
    api_client.get(`/events_by_date?date=${date ? new Date(date) : new Date()}`)
      .then((response) => {
        setEvents(response.data)
        setSelectedDate(moment.utc(date).toISOString())
      })
      .catch((error) => console.log(error))
  }

  const fetchWeekEvents = (week_start, week_end) => {
    api_client.get(`/events_by_week?start=${new Date(week_start)}&end=${new Date(week_end)}`)
      .then((response) => {
        setMarkedDates(markDates(response.data))
      })
      .catch((error) => console.log(error))
  }

  const markDates = (events) => {
    let marked_dates = []
    events.forEach(event => {
      marked_dates.push({
        date: moment(`${event.starts_at}`, "YYYY-MM-DD"),
        dots: [
          {
            color: "#fff",
          },
        ],
      });
    })
    return marked_dates
  }

  return (
    <View style={{flex: 1}}>
      <CalendarStrip
        style={{ height: 120, paddingVertical: 10 }}
        calendarColor={'#4286f4'}
        calendarHeaderStyle={{ color: '#fff' }}
        selectedDate={selectedDate}
        dateNumberStyle={{ color: '#fff' }}
        dateNameStyle={{ color: '#fff' }}
        iconContainer={{ flex: 0.1 }}
        calendarAnimation={{ type: 'parallel', duration: 300 }}
        daySelectionAnimation={{
          type: "background",
          highlightColor: '#fff',
        }}
        markedDates={markedDates}
        onWeekChanged={(start, end) => fetchWeekEvents(start, end)}
        onDateSelected={date => eventsFromToday(date)}
        highlightDateNameStyle={{ color: '#2196F3' }}
        highlightDateNumberStyle={{ color: '#2196F3' }}
        iconLeft={require('../../assets/left-arrow.png')}
        iconRight={require('../../assets/right-arrow.png')}
      />

      {events?.all_day_events?.length > 0 || events?.today_events?.length > 0 ?
        <ScrollView style={styles.events} showsVerticalScrollIndicator={false}>
          {events.all_day_events && events.all_day_events.length > 0 && events.all_day_events.map(event =>
            <TouchableOpacity key={event.id} onPress={() => navigator.navigate("EventDetails", { event })} style={[styles.eventContainer, styles.allDayEvent]}>
              <View style={[styles.eventLeftSide, {borderRightColor: '#fff'}]}>
                <View style={styles.allDayEventBadge}>
                  <Text style={styles.allDayEventText}>All day</Text>
                </View>
              </View>
              <View style={styles.eventRightSide}>
                <Text style={{ color: '#fff' }}>{event.summary}</Text>
              </View>
            </TouchableOpacity>
          )}
          {events.today_events && events.today_events.length > 0 && events.today_events.map(event =>
            <TouchableOpacity key={event.id} onPress={() => navigator.navigate("EventDetails", { event })}style={[styles.eventContainer, styles.event]}>
              <View style={[styles.eventLeftSide, {borderRightColor: '#4286f4'}]}>
                <Text style={{fontWeight: 'bold'}}>{moment(event.starts_at).format("hh:mm a")}</Text>
                <Text style={{color: "#aaabbb"}}>{moment(event.finishes_at).format("hh:mm a")}</Text>
              </View>
              <View style={styles.eventRightSide}>
                <Text>{event.summary}</Text>
              </View>
            </TouchableOpacity>
          )}
        </ScrollView>
        :
        <View style={styles.noEvents}>
          <Text>No events to show.</Text>
        </View>
      }

      <View style={styles.createEventButton}>
        <TouchableOpacity onPress={() => navigator.navigate("EventForm", { date: selectedDate })} >
          <FeatherIcon name="plus" color="#fff" size={35} />
        </TouchableOpacity>
      </View>
    </View>
  )
}

export default Calendar

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  events: {
    flex: 1,
    paddingBottom: 20
  },
  eventLeftSide: {
    flexDirection: 'column',
    borderRightWidth: 3,
    paddingRight: 8,
  },
  eventRightSide: {
    flex: 1,
    marginLeft: 12
  },
  eventContainer: {
    paddingVertical: 24,
    paddingLeft: 22,
    paddingRight: 4,
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
    borderBottomWidth: 1,
  },
  allDayEvent: {
    backgroundColor: "#2196F3",
    borderBottomColor: "#4286f4"
  },
  event: {
    backgroundColor: "#fff",
    borderBottomColor: "#ccc"
  },
  allDayEventBadge: {
    backgroundColor: "#fff",
    paddingHorizontal: 12,
    height: 30,
    justifyContent: 'center',
    borderRadius: 25
  },
  allDayEventText: {
    fontSize: 13,
    color: "#4286f4",
    fontWeight: "bold",
  },
  noEvents: {
    alignItems: "center",
    justifyContent: "center",
    flex: 1
  },
  createEventButton: { 
    position: 'absolute', 
    bottom: 20,
    right: 15, 
    backgroundColor: "#2196F3", 
    padding: 10, 
    borderRadius: 50 
  }
});