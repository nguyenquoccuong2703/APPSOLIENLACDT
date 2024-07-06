import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import LoginScreen from './LoginScreen';
import HomeTeacher from './Teacher/HomeTeacher';
import HomeStudent from './Student/HomeStudent';
import Personal from './Personal';
import ChangePassword from './ChangePassword';
const Stack = createStackNavigator();

function AppNavigator() {
  return (
    <Stack.Navigator initialRouteName="Login">
      <Stack.Screen
        name="Login"
        component={LoginScreen}
        options={{ headerShown: false }}
      />
      <Stack.Screen
        name="HomeTeacher"
        component={HomeTeacher}
        options={{ headerShown: false }}
      />
      <Stack.Screen
        name="HomeStudent"
        component={HomeStudent}
        options={{ headerShown: false }}
      />
      <Stack.Screen
        name="Personal"
        component={Personal}
        options={{ headerShown: false }}
      />
      <Stack.Screen
        name="ChangePassword"
        component={ChangePassword}
        options={{ headerShown: false }}
      />
    </Stack.Navigator>

  );
}

export default AppNavigator;
