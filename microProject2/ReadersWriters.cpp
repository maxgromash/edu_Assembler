#define HAVE_STRUCT_TIMESPEC
#define _CRT_SECURE_NO_WARNINGS
#define _CRT_RAND_S
#include <pthread.h>
#include <stdio.h>
#include <semaphore.h>
#include <conio.h>
#include <stdlib.h>
#include <thread>
#include <vector>

//Для использования sleep_for() из std::
using namespace std::chrono_literals;

const int SZE = 11;
const int COUNT_OF_ITERATIONS = 100;
int database[SZE] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

sem_t  semaphore;

void* writer(void* number) {
	int threadNum = *((int*)number); //Назначаем номер потока
	int data;
	int ind;
	int result;
	for (int i = 0; i < COUNT_OF_ITERATIONS; i++) 
	{
		srand(time(NULL)); //Необходим для корректной работы рандома
		sem_wait(&semaphore); //Ждём доступ
		data = rand() % 20; //генерируем данные
		ind = rand() % SZE; //генерируем индекс
		result = database[ind]; //Читаем старое значение
		database[ind] = data; //Записываем новое значение
		std::this_thread::sleep_for(1s); 
		printf("Writer %d: reads old value %d from the cell [%d] and writes new value %d to the cell [%d]   \n", threadNum, result, ind, data, ind, result);
		sem_post(&semaphore);
	}
	return nullptr;
}


void* reader(void* number) {
	int threadNum = *((int*)number); //Назначаем номер потока
	int result;
	int ind;
	for (int i = 0; i < COUNT_OF_ITERATIONS; i++) {
		srand(time(NULL)); //Необходим для корректной работы рандома
		ind = rand() % SZE; //Генерируем индекс
		result = database[ind]; //Читаем значение из  базы 
		
		switch (threadNum) //В зависимости от номера потока рассчитывается время его сна
		{
		case 1:
			std::this_thread::sleep_for(1s);
			break;
		case 2:
			std::this_thread::sleep_for(2s);
			break;
		case 3:
			std::this_thread::sleep_for(3s);
			break;
		case 0:
			std::this_thread::sleep_for(2s);
			break;
		default:
			break;
		}
		printf("Reader %d: reads value %d from cell [%d]\n", threadNum, result, ind);
	}
	return nullptr;
}

int main() {
	srand(time(NULL));
	//Инициализация семафораы
	sem_init(&semaphore, 0, 1);

	//Создаём и запускаем потоки
	pthread_t writers[3];
	pthread_t readers[3];
	int readersNum[3];
	int writersNum[3];
	for (int i = 0; i < 3; i++) {
		writersNum[i] = i + 1;
		readersNum[i] = i + 1;
		pthread_create(&writers[i], NULL, writer, (void*)(writersNum + i));
		pthread_create(&readers[i], nullptr, reader, (void*)(readersNum + i));
	}
	int x = 0;
	reader((void*)&x);

	//Удаляем семафор из памяти
	sem_destroy(&semaphore);
	return 0;
}