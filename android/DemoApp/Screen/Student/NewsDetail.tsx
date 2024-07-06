import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { RouteProp, useRoute } from '@react-navigation/native';
import { RootStackParamList } from '../NavigationTypes';

interface NewsItem {
    id: number;
    title: string;
    description: string;
    content: string;
}

const NewsDetail: React.FC = () => {
    const route = useRoute<RouteProp<RootStackParamList, 'NewsDetail'>>();
    const { newsId } = route.params;
    const [newsItem, setNewsItem] = useState<NewsItem | null>(null);
    const [error, setError] = useState<string | null>(null);

    const fetchNewsDetail = async () => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/News/${newsId}`);
            const data: NewsItem = await response.json();
            setNewsItem(data);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin chi tiết tin tức:', error);
            setError('Lỗi khi lấy thông tin chi tiết tin tức.');
        }
    };

    useEffect(() => {
        fetchNewsDetail();
    }, []);

    return (
        <ScrollView style={styles.container}>
            {error && <Text style={styles.errorText}>{error}</Text>}
            {newsItem && (
                <View>
                    <Text style={styles.title}>{newsItem.title}</Text>
                    <Text style={styles.description}>{newsItem.description}</Text>
                    <Text style={styles.content}>{newsItem.content}</Text>
                </View>
            )}
        </ScrollView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f2f2f2',
        padding: 20,
    },
    title: {
        fontSize: 24,
        fontWeight: 'bold',
        marginBottom: 10,
    },
    description: {
        fontSize: 16,
        color: '#555',
        marginBottom: 20,
    },
    content: {
        fontSize: 14,
        color: '#333',
    },
    errorText: {
        fontSize: 16,
        color: 'red',
        textAlign: 'center',
        marginBottom: 20,
    },
});

export default NewsDetail;
