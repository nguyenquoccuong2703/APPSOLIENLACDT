import React, { useState } from 'react';
import { View, Text, StyleSheet, TextInput, Button, Alert, TouchableOpacity } from 'react-native';
import { useUser } from './UserContext'; // Đường dẫn đến file UserContext
import { useNavigation } from '@react-navigation/native';

const ChangePassword: React.FC = () => {
    const { user } = useUser();
    const [oldPassword, setOldPassword] = useState('');
    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [error, setError] = useState('');
    const [successMessage, setSuccessMessage] = useState('');
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
            'Mật khẩu đã thay đổi bạn có muốn đăng nhập lại không?',
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

    const handleChangePassword = async () => {
        if (newPassword !== confirmPassword) {
            setError('Mật khẩu mới không khớp. Vui lòng nhập lại.');
            return;
        }

        try {
            // Fetch user data to verify the old password
            const userResponse = await fetch(`http://192.168.137.1:3000/users/${user?.id}`);
            const userData = await userResponse.json();

            if (userData.PassWord !== oldPassword) {
                setError('Mật khẩu cũ không đúng. Vui lòng nhập lại.');
                return;
            }

            // Proceed with updating the password
            const response = await fetch(`http://192.168.137.1:3000/users/${user?.id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    id: user?.id,
                    UserName: user?.UserName,
                    PassWord: newPassword,
                    UserType: user?.UserType
                }),
            });

            const text = await response.text();
            console.log('Server response:', text);
            let data;
            try {
                data = JSON.parse(text);
            } catch (err) {
                console.error('Error parsing JSON:', err);
                setError('Invalid server response.');
                return;
            }

            if (response.ok) {
                setSuccessMessage('Đổi mật khẩu thành công.');
                setError('');
                setOldPassword('');
                setNewPassword('');
                setConfirmPassword('');
                confirmLogout(); // Gọi hàm confirmLogout()
            } else {
                setError(data.message || 'Đã xảy ra lỗi khi đổi mật khẩu.');
                setSuccessMessage('');
            }
        } catch (error) {
            console.error('Error changing password:', error);
            setError('Đã xảy ra lỗi khi đổi mật khẩu.');
            setSuccessMessage('');
        }
    };

    return (
        <View style={styles.container}>
            <Text style={styles.title}>Đổi Mật Khẩu</Text>
            <TextInput
                style={styles.input}
                placeholder="Mật khẩu cũ"
                secureTextEntry
                value={oldPassword}
                onChangeText={setOldPassword}
            />
            <TextInput
                style={styles.input}
                placeholder="Mật khẩu mới"
                secureTextEntry
                value={newPassword}
                onChangeText={setNewPassword}
            />
            <TextInput
                style={styles.input}
                placeholder="Xác nhận mật khẩu mới"
                secureTextEntry
                value={confirmPassword}
                onChangeText={setConfirmPassword}
            />
            {error ? <Text style={styles.error}>{error}</Text> : null}
            {successMessage ? <Text style={styles.success}>{successMessage}</Text> : null}
            <TouchableOpacity style={styles.button} onPress={handleChangePassword}>
                <Text style={styles.buttonText}>Thay đổi mật khẩu</Text>
            </TouchableOpacity>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        padding: 20,
        backgroundColor: '#f0f0f0',
    },
    title: {
        fontSize: 24,
        fontWeight: 'bold',
        marginBottom: 20,
        textAlign: 'center',
        color: '#333',
    },
    input: {
        width: '100%',
        height: 40,
        borderColor: 'gray',
        borderWidth: 1,
        marginBottom: 10,
        paddingHorizontal: 10,
        borderRadius: 5,
        backgroundColor: '#fff',
    },
    button: {
        width: '100%',
        height: 50,
        backgroundColor: '#007BFF',
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 5,
        marginTop: 10,
    },
    buttonText: {
        color: '#fff',
        fontSize: 18,
        fontWeight: 'bold',
    },
    error: {
        color: 'red',
        marginBottom: 10,
    },
    success: {
        color: 'green',
        marginBottom: 10,
    },
});

export default ChangePassword;
