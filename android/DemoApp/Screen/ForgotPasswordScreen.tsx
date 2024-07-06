import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, SafeAreaView, Alert } from 'react-native';
import { useNavigation, NavigationProp, ParamListBase } from '@react-navigation/native';

interface ForgotPasswordScreenProps {
  navigation: NavigationProp<ParamListBase>;
}

const ForgotPasswordScreen: React.FC<ForgotPasswordScreenProps> = ({ navigation }) => {
  const [username, setUsername] = useState('');

  const handleSendOTP = async () => {
    // Fetch user information based on username
    try {
      const response = await fetch(`http://192.168.137.1:3000/users?UserName=${username}`);
      const users = await response.json();
      const user = users[0]; // Assuming usernames are unique

      if (user) {
        const studentResponse = await fetch(`http://192.168.137.1:3000/Student?UserId=${user.id}`);
        const students = await studentResponse.json();
        const student = students[0]; // Assuming one student per user

        if (student) {
          const email = student.email; // Sử dụng email của sinh viên
          const otp = generateOTP();
          
          // Log OTP for development purposes
          console.log(`Generated OTP for ${email}: ${otp}`);

          const otpResponse = await fetch('http://192.168.137.1:3001/send-otp', { // Đảm bảo URL là đúng
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ email, otp }), // Include OTP in the body
          });

          const otpData = await otpResponse.json();

          if (otpData.success) {
            Alert.alert('OTP Sent', `OTP has been sent to the email associated with ${username}.`);
            navigation.navigate('VerifyOTP', { username, email, otp });
          } else {
            Alert.alert('Error', 'Failed to send OTP.');
          }
        } else {
          Alert.alert('Error', 'No student information found for this user.');
        }
      } else {
        Alert.alert('Error', 'No user found with this username.');
      }
    } catch (error) {
      console.error('Error fetching user information:', error);
      Alert.alert('Error', 'Failed to fetch user information.');
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Quên mật khẩu</Text>
        <Text>Nhập tên đăng nhập của bạn để nhận mã OTP.</Text>
      </View>
      <View style={styles.form}>
        <TextInput
          placeholder="Tên đăng nhập"
          style={styles.input}
          value={username}
          onChangeText={setUsername}
          autoCapitalize="none"
        />
        <TouchableOpacity style={styles.button} onPress={handleSendOTP}>
          <Text style={styles.buttonText}>Gửi mã OTP</Text>
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

export default ForgotPasswordScreen;

// Helper functions
function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}
