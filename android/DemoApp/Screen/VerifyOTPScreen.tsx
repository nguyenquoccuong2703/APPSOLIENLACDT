import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, SafeAreaView, Alert } from 'react-native';
import { useNavigation, NavigationProp, RouteProp } from '@react-navigation/native';
import { RootStackParamList } from './NavigationTypes';

interface VerifyOTPScreenProps {
  navigation: NavigationProp<RootStackParamList, 'VerifyOTP'>;
  route: RouteProp<RootStackParamList, 'VerifyOTP'>;
}

const VerifyOTPScreen: React.FC<VerifyOTPScreenProps> = ({ navigation, route }) => {
  const { email, username, otp: generatedOTP } = route.params;
  const [otp, setOTP] = useState('');

  const handleVerifyOTP = async () => {
    try {
      const response = await fetch('http://192.168.137.1:3001/verify-otp', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, otp }),
      });

      const data = await response.json();

      if (data.success) {
        Alert.alert('Success', 'OTP verified successfully.');
        navigation.navigate('ResetPassword', { email, username });
      } else {
        Alert.alert('Error', 'Failed to verify OTP. Please try again.');
      }
    } catch (error) {
      console.error('Error verifying OTP:', error);
      Alert.alert('Error', 'Failed to verify OTP.');
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Verify OTP</Text>
        <Text>Enter the OTP sent to your email address.</Text>
      </View>
      <View style={styles.form}>
        <TextInput
          placeholder="OTP"
          style={styles.input}
          value={otp}
          onChangeText={setOTP}
        />
        <TouchableOpacity style={styles.button} onPress={handleVerifyOTP}>
          <Text style={styles.buttonText}>Verify OTP</Text>
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

export default VerifyOTPScreen;
