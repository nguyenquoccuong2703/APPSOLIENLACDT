import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, SafeAreaView, Alert } from 'react-native';
import { useNavigation, RouteProp, NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from './NavigationTypes';

interface ResetPasswordScreenProps {
  route: RouteProp<RootStackParamList, 'ResetPassword'>;
  navigation: NavigationProp<RootStackParamList, 'ResetPassword'>;
}

const ResetPasswordScreen: React.FC<ResetPasswordScreenProps> = ({ navigation, route }) => {
  const { username } = route.params;
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  const handleResetPassword = async () => {
    if (newPassword !== confirmPassword) {
      Alert.alert('Error', 'Passwords do not match. Please try again.');
      return;
    }

    try {
      const response = await fetch('http://192.168.137.1:3000/reset-password', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ username, newPassword }),
      });

      const data = await response.json();

      if (data.success) {
        Alert.alert('Success', 'Password reset successfully.');
        navigation.navigate('Login');
      } else {
        Alert.alert('Error', 'Failed to reset password. Please try again.');
      }
    } catch (error) {
      console.error('Error resetting password:', error);
      Alert.alert('Error', 'Failed to reset password.');
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Reset Password</Text>
        <Text>Enter your new password below.</Text>
      </View>
      <View style={styles.form}>
        <TextInput
          placeholder="New Password"
          style={styles.input}
          value={newPassword}
          onChangeText={setNewPassword}
          secureTextEntry
        />
        <TextInput
          placeholder="Confirm Password"
          style={styles.input}
          value={confirmPassword}
          onChangeText={setConfirmPassword}
          secureTextEntry
        />
        <TouchableOpacity style={styles.button} onPress={handleResetPassword}>
          <Text style={styles.buttonText}>Reset Password</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f7f7f7',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  header: {
    marginBottom: 40,
    alignItems: 'center',
  },
  title: {
    fontSize: 30,
    color: '#333',
    fontWeight: 'bold',
    marginBottom: 10,
  },
  form: {
    width: '100%',
    padding: 20,
    backgroundColor: '#fff',
    borderRadius: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 5,
    elevation: 3,
  },
  input: {
    borderColor: '#cccccc',
    borderWidth: 1,
    padding: 10,
    marginBottom: 10,
    borderRadius: 5,
    width: '100%',
  },
  button: {
    backgroundColor: '#0000ff',
    paddingVertical: 12,
    paddingHorizontal: 20,
    alignItems: 'center',
    borderRadius: 5,
    width: '100%',
  },
  buttonText: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default ResetPasswordScreen;
