import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { SafeAreaView } from 'react-native-safe-area-context';
import moment from 'moment';
import ReturnButton from '../../components/shared/return_button';
import api_client from '../../config/api_client';
import FeatherIcon from 'react-native-vector-icons/Feather'
import { TouchableOpacity } from 'react-native-gesture-handler';
import {
  Menu,
  MenuOptions,
  MenuOption,
  MenuTrigger,
} from "react-native-popup-menu";
import { useNavigation } from '@react-navigation/native';

const EventDetails = ({ route }) => {
  const { event } = route.params;
  const navigation = useNavigation();

  const deleteEvent = () => {
    api_client.delete(`/events/${event.id}`)
      .then(() => {
        let date = moment.utc(event.starts_at).toISOString()
        navigation.navigate("Calendar", { date })
      })
      .catch(err => console.error(err))
  }

  const MenuPopup = () => {
    return (
      <Menu >
        <MenuTrigger>
          <FeatherIcon name="more-vertical" size={25} />
        </MenuTrigger>
        <MenuOptions optionsContainerStyle={{ borderRadius: 5 }}>
          <MenuOption onSelect={deleteEvent}>
            <Text style={{ padding: 5, fontSize: 18 }}>Delete</Text>
          </MenuOption>
        </MenuOptions>
      </Menu>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <View style={styles.header}>
        <ReturnButton />
        <View style={{ flexDirection: 'row' }} >
          <TouchableOpacity onPress={() => navigation.navigate("EventForm", { event })} style={{ marginRight: 15 }}>
            <FeatherIcon name="edit-2" size={26} />
          </TouchableOpacity>
          <MenuPopup event={event?.id} />
        </View>
      </View>
      <View style={styles.eventDetails}>
        <Text style={{ fontSize: 24 }}>{event.summary}</Text>
        <Text style={{ fontSize: 16 }}>{moment.utc(event.starts_at).format("dddd, MMM DD")} {event.is_all_day ? "" : `• ${moment(event.starts_at).format("hh:mm A")} - ${moment(event.finishes_at).format("hh:mm A")}`}</Text>
      </View>

      {event?.description &&
        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
          <View style={{ paddingVertical: 10}}>
            <View style={{ flexDirection: 'row' }}>
              <FeatherIcon name="align-left" size={24} style={{ paddingHorizontal: 12 }} />
              <Text style={{ fontSize: 16 }}>Description</Text>
            </View>
            <Text style={{ fontSize: 16, paddingHorizontal: 50 }}>{event.description}</Text>
          </View>
        </View>
      }
      <View style={{ flexDirection: 'row', alignItems: 'center' }}>
        <FeatherIcon name="calendar" size={24} style={{ paddingHorizontal: 12 }} />
        <View style={{ paddingVertical: 10 }}>
          <Text style={{ fontSize: 16 }}>Organizer</Text>
          <Text style={{ fontSize: 16 }}>{event.organizer_email}</Text>
        </View>
      </View>
    </SafeAreaView>
  )
}

export default EventDetails

const styles = StyleSheet.create({
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginHorizontal: 10,
    marginTop: 10
  },
  eventDetails: {
    paddingHorizontal: 50,
    marginTop: 20,
    marginBottom: 10
  }
})