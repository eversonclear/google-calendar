
import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import { createDrawerNavigator } from '@react-navigation/drawer';
import Header from './components/shared/header';
import HomePage from './screens/home_page';
import Calendars from './screens/calendar/calendars';
import Calendar from './screens/calendar/calendar';
import EventDetails from './screens/calendar/event_details';
import EventForm from './screens/calendar/event_form';
import api_client from './config/api_client';
import { useAuth } from './context/auth';
import { CustomDrawerContent } from './components/shared/custom_drawer_navigator';
import UserPage from './screens/user_page';
// Imports End

const Drawer = createDrawerNavigator();
const Stack = createStackNavigator();

export default function PrivateRoutes() {
  const { user } = useAuth();
  api_client.defaults.headers['Authorization'] = `Bearer ${user?.token}`;
    
  const DrawerRoutes = () =>
    <Drawer.Navigator drawerContent={(props) => <CustomDrawerContent {...props} />} backBehavior='initialRoute' initialRouteName='Home' screenOptions={{ sceneContainerStyle: { backgroundColor: '#fff' } }}>
      {/* Drawer Routes Start */}
      <Drawer.Screen name='Home' component={HomePage} />
      <Drawer.Screen name='Calendars' component={Calendars} />
      <Drawer.Screen name='Calendar' component={Calendar} />
      {/* Drawer Routes End */} 
    </Drawer.Navigator>

  return (
    <Stack.Navigator initialRouteName='Root' screenOptions={{cardStyle: { backgroundColor: '#fff' }}}>
      <Stack.Group>
      {/* Stack Routes Start */}
       <Stack.Screen name='Root' component={DrawerRoutes} options={{headerShown: false}}/>
       <Stack.Screen name='EventDetails' component={EventDetails} options={{headerShown: false}}/>
       <Stack.Screen name='EventForm' component={EventForm} options={{headerShown: false}}/>
       <Stack.Screen name='Profile' component={UserPage} options={{headerShown: false}}/>
      {/* Stack Routes End */}
      </Stack.Group>
    </Stack.Navigator>

  );
}
