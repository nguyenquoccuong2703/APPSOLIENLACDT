import React, { useState } from 'react';
import { View, Text, TextInput, Button, Alert, StyleSheet, ScrollView } from 'react-native';
import { RouteProp, useRoute } from '@react-navigation/native';
import { RootStackParamList } from '../NavigationTypes';
import { useUser } from '../UserContext';

const NotificationInput: React.FC = () => {
    const route = useRoute<RouteProp<RootStackParamList, 'NotificationInput'>>();
    const { classId, studentId } = route.params;
    const { user } = useUser();
    const [nameContent, setNameContent] = useState('');
    const [content, setContent] = useState('');

    const handleSubmit = async () => {
        if (!nameContent || !content) {
            Alert.alert('Lỗi', 'Vui lòng điền đầy đủ thông tin.');
            return;
        }

        const newNotification = {
            SenderId: user?.id,
            NameContent: nameContent,
            Content: content,
            Timestamp: new Date().toISOString(),
            RecipientType: classId ? 'Class' : 'Student',
            RecipientIds: { IdClass: classId, IdStudent: studentId },
        };

        try {
            const response = await fetch('http://192.168.137.1:3000/Notifications', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(newNotification),
            });

            if (response.ok) {
                Alert.alert('Thành công', 'Thông báo đã được gửi.');
                setNameContent('');
                setContent('');
            } else {
                throw new Error('Failed to send notification.');
            }
        } catch (error) {
            console.error('Error sending notification:', error);
            Alert.alert('Lỗi', 'Có lỗi xảy ra khi gửi thông báo.');
        }
    };

    return (
        <ScrollView style={styles.container}>
            <Text style={styles.sectionText}>Gửi Thông Báo</Text>
            <TextInput
                style={styles.input}
                placeholder="Tiêu đề"
                value={nameContent}
                onChangeText={setNameContent}
            />
            <TextInput
                style={styles.input}
                placeholder="Nội dung"
                value={content}
                onChangeText={setContent}
                multiline
            />
            <Button title="Gửi thông báo" onPress={handleSubmit} color="#007bff" />
        </ScrollView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f0f0f0',
        padding: 20,
    },
    sectionText: {
        fontSize: 24,
        color: '#333',
        marginBottom: 20,
        fontWeight: 'bold',
        textAlign: 'center',
    },
    input: {
        height: 40,
        borderColor: '#ccc',
        borderWidth: 1,
        borderRadius: 5,
        marginBottom: 15,
        paddingHorizontal: 10,
        backgroundColor: '#fff',
    },
});

export default NotificationInput;
