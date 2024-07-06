import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Alert } from 'react-native';
import { useNavigation } from '@react-navigation/native';

const SettingsScreen: React.FC = () => {
  const navigation = useNavigation();

  const handleLogout = () => {
    // Implement your logout logic here
    // For example, clear user data, tokens, etc.
    Alert.alert('Logged Out', 'You have been logged out successfully.');
    // Navigate to the login screen or any other screen
    navigation.navigate('Login' as never);
  };

  const confirmLogout = () => {
    Alert.alert(
      'Confirm Logout',
      'Are you sure you want to logout?',
      [
        {
          text: 'No',
          onPress: () => console.log('Logout cancelled'),
          style: 'cancel',
        },
        {
          text: 'Yes',
          onPress: handleLogout,
        },
      ],
      { cancelable: false }
    );
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Log Out</Text>
      <TouchableOpacity style={styles.logoutButton} onPress={confirmLogout}>
        <Text style={styles.logoutButtonText}>Logout</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 24,
    marginBottom: 20,
  },
  logoutButton: {
    backgroundColor: '#f44336',
    paddingVertical: 10,
    paddingHorizontal: 20,
    borderRadius: 5,
  },
  logoutButtonText: {
    color: '#fff',
    fontSize: 18,
  },
});

export default SettingsScreen;
