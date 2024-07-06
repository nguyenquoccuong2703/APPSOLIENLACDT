import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { useNavigation, NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../NavigationTypes';

interface NewsItem {
    id: number;
    title: string;
    description: string;
    content: string;
}

const NewsList: React.FC = () => {
    const [news, setNews] = useState<NewsItem[]>([]);
    const [error, setError] = useState<string | null>(null);
    const navigation = useNavigation<NavigationProp<RootStackParamList>>();

    const fetchNews = async () => {
        try {
            const response = await fetch(`http://192.168.137.1:3000/News`);
            const data: NewsItem[] = await response.json();
            setNews(data);
        } catch (error) {
            console.error('Lỗi khi lấy thông tin tin tức:', error);
            setError('Lỗi khi lấy thông tin tin tức.');
        }
    };

    useEffect(() => {
        fetchNews();
    }, []);

    return (
        <ScrollView style={styles.container}>
            <Text style={styles.header}>Tin Tức</Text>
            {error && <Text style={styles.errorText}>{error}</Text>}
            {news.map((item) => (
                <TouchableOpacity
                    key={item.id}
                    style={styles.newsItem}
                    onPress={() => navigation.navigate('NewsDetail', { newsId: item.id })}
                >
                    <Text style={styles.newsTitle}>{item.title}</Text>
                    <Text style={styles.newsDescription}>{item.description}</Text>
                </TouchableOpacity>
            ))}
        </ScrollView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f2f2f2',
        padding: 20,
    },
    header: {
        fontSize: 24,
        fontWeight: 'bold',
        marginBottom: 20,
        textAlign: 'center',
    },
    newsItem: {
        backgroundColor: '#fff',
        padding: 20,
        marginVertical: 10,
        borderRadius: 10,
        shadowColor: '#000',
        shadowOffset: {
            width: 0,
            height: 2,
        },
        shadowOpacity: 0.25,
        shadowRadius: 3.84,
        elevation: 5,
    },
    newsTitle: {
        fontSize: 18,
        fontWeight: 'bold',
    },
    newsDescription: {
        marginTop: 10,
        fontSize: 14,
        color: '#555',
    },
    errorText: {
        fontSize: 16,
        color: 'red',
        textAlign: 'center',
        marginBottom: 20,
    },
});

export default NewsList;
