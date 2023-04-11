import { NavigationContainer } from '@react-navigation/native'
import React, { useEffect } from 'react';
import { configureGoogle } from './src/config/google_auth'
import { Provider } from 'react-redux';
import { createStore } from 'redux';
import { AuthProvider } from './src/context/auth';
import 'react-native-gesture-handler';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';
import { MenuProvider } from 'react-native-popup-menu';
import Navigator from './src/Navigator';
import reducers from './src/reducers';
import { StatusBar } from 'react-native';

const store = createStore(reducers);

export default function App() {
  useEffect(configureGoogle, [])
  Platform.OS === 'ios' && StatusBar.setBarStyle('dark-content', true);
  return (
  <AuthProvider>
    <Provider store={store}>
         <MenuProvider>
      <SafeAreaProvider>
        <NavigationContainer>
          <Navigator />
        </NavigationContainer>
      </SafeAreaProvider>
         </MenuProvider>
      <Toast />
    </Provider>
  </AuthProvider>
  );
}