import * as React from 'react';
import { useState, useEffect, useCallback } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  SafeAreaView,
  StyleSheet,
  StatusBar,
  Alert,
  TextInput
} from 'react-native';
import { useNavigation, NavigationProp, ParamListBase, useFocusEffect } from '@react-navigation/native';
import { useUser } from './UserContext';

interface LoginScreenProps {
  navigation: NavigationProp<ParamListBase>;
}

interface CustomCheckboxProps {
  checked: boolean;
  onPress: () => void;
}

const CustomCheckbox: React.FC<CustomCheckboxProps> = ({ checked, onPress }) => {
  return (
    <TouchableOpacity onPress={onPress} style={styles.checkboxContainer}>
      <View style={[styles.checkbox, checked && styles.checkedCheckbox]}>
        {checked && <Text style={styles.checkIcon}>✓</Text>}
      </View>
      <Text style={styles.label}>Ghi nhớ mật khẩu</Text>
    </TouchableOpacity>
  );
};

const LoginScreen: React.FC<LoginScreenProps> = ({ navigation }) => {
  type User = {
    id: string;
    UserName: string;
    PassWord: string;
    UserType: string;
  };
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [rememberPassword, setRememberPassword] = useState(false);
  const [users, setUsers] = useState<User[]>([]);
  const { setUser } = useUser();

  const fetchUsers = async () => {
    try {
      const response = await fetch('http://192.168.137.1:3000/users');
      const data = await response.json();
      setUsers(data);
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  useFocusEffect(
    useCallback(() => {
      fetchUsers();
    }, [])
  );

  const handleLogin = async () => {
    await fetchUsers(); // Làm mới dữ liệu trước khi đăng nhập
    const user = users.find(u => u.UserName === username && u.PassWord === password);
    if (user) {
      setUser(user);
      if (user.UserType === '1') {
        Alert.alert('Đăng Nhập', 'Đăng Nhập Quyền Phụ Huynh');
        navigation.navigate('HomeStudent', { user });
      } else if (user.UserType === '2') {
        Alert.alert('Đăng Nhập', 'Giáo Viên');
        navigation.navigate('HomeTeacher', { user });
      } else {
        Alert.alert('Lỗi', 'Loại người dùng không hợp lệ.');
      }
    } else {
      Alert.alert('Lỗi', 'Tên người dùng hoặc mật khẩu không đúng.');
    }
  };

  const handleCheckboxToggle = () => {
    setRememberPassword(!rememberPassword);
  };

  const handleForgotPassword = () => {
    navigation.navigate('ForgotPasswordScreen');
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar backgroundColor={'#ffffff'} barStyle={"dark-content"} />
      <View style={styles.header}>
        <Text style={styles.title}>Đăng nhập</Text>
        <Text>Khi đăng nhập, bạn đồng ý với</Text>
        <View style={{ flexDirection: "row" }}>
          <Text>điều khoản và </Text>
          <TouchableOpacity onPress={() => Alert.alert('Thông báo', 'Chức năng này sẽ sớm có')}>
            <Text style={styles.link}>chính sách bảo mật</Text>
          </TouchableOpacity>
          <Text> của chúng tôi</Text>
        </View>
      </View>
      <View style={styles.form}>
        <View style={styles.group}>
          <TextInput
            placeholder="Tên người dùng"
            style={styles.input}
            value={username}
            onChangeText={(value) => setUsername(value)}
          />
          <TextInput
            placeholder="Mật khẩu"
            style={styles.input}
            value={password}
            onChangeText={(value) => setPassword(value)}
            secureTextEntry
          />
        </View>
        <CustomCheckbox
          checked={rememberPassword}
          onPress={handleCheckboxToggle}
        />
        <TouchableOpacity style={styles.button} onPress={handleLogin}>
          <Text style={styles.buttonText}>Đăng nhập</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={handleForgotPassword}>
          <Text style={styles.forgotPassword}>Quên mật khẩu?</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f7f7f7', // Light gray background
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  header: {
    marginBottom: 40, // Spacing between header and form
    alignItems: 'center',
  },
  title: {
    fontSize: 30,
    color: '#333', // Darker text color
    fontWeight: 'bold',
    marginBottom: 10,
  },
  link: {
    color: 'blue',
  },
  form: {
    width: '100%',
    padding: 20,
    backgroundColor: '#fff', // White background for form
    borderRadius: 10, // Rounded corners for form container
    shadowColor: '#000', // Add subtle shadow
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 5,
    elevation: 3,
  },
  group: {
    marginBottom: 20,
  },
  input: {
    borderColor: '#cccccc',
    borderWidth: 1,
    padding: 10,
    marginBottom: 10,
    borderRadius: 5, // Rounded corners for input fields
    width: '100%',
  },
  checkboxContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 20,
  },
  checkbox: {
    width: 20,
    height: 20,
    borderWidth: 1,
    borderColor: '#cccccc',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 10,
    borderRadius: 3,
  },
  checkedCheckbox: {
    backgroundColor: '#0000ff',
  },
  checkIcon: {
    color: '#ffffff',
    fontSize: 16,
  },
  label: {
    fontSize: 16,
    color: '#333',
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
  forgotPassword: {
    color: '#0000ff',
    textAlign: 'center',
    marginTop: 10,
  },
});

export default LoginScreen;
