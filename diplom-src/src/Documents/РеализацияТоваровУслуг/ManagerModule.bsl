
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
        КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
        КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
        КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(Метаданные.Документы.РеализацияТоваровУслуг);
        КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

Процедура ПриОпределенииНастроекПечати(НастройкиОбъекта) Экспорт	
	НастройкиОбъекта.ПриДобавленииКомандПечати = Истина;
КонецПроцедуры

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Анкета клиента
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ВКМ_АктОбОказанныхУслугах";
	КомандаПечати.Представление = НСтр("ru = 'Печать акта'");
	КомандаПечати.Порядок = 10;

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ВКМ_АктОбОказанныхУслугах");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьАктаОбОказанныхУслугах(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт об оказанных услугах'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ПФ_MXL_ВКМ_АктОбОказанныхУслугах";
	КонецЕсли;

КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПечатьАктаОбОказанныхУслугах(МассивОбъектов, ОбъектыПечати) 

	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Макет = Документы.РеализацияТоваровУслуг.ПолучитьМакет("ПФ_MXL_ВКМ_АктОбОказанныхУслугах");
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
	               |	РеализацияТоваровУслуг.ВерсияДанных КАК ВерсияДанных,
	               |	РеализацияТоваровУслуг.ПометкаУдаления КАК ПометкаУдаления,
	               |	РеализацияТоваровУслуг.Номер КАК Номер,
	               |	РеализацияТоваровУслуг.Дата КАК Дата,
	               |	РеализацияТоваровУслуг.Проведен КАК Проведен,
	               |	РеализацияТоваровУслуг.Организация КАК Организация,
	               |	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
	               |	РеализацияТоваровУслуг.Договор КАК Договор,
	               |	РеализацияТоваровУслуг.СуммаДокумента КАК СуммаДокумента,
	               |	РеализацияТоваровУслуг.Основание КАК Основание,
	               |	РеализацияТоваровУслуг.Ответственный КАК Ответственный,
	               |	РеализацияТоваровУслуг.Комментарий КАК Комментарий,
	               |	РеализацияТоваровУслуг.Услуги.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Услуги
	               |ИЗ
	               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	               |ГДЕ
	               |	РеализацияТоваровУслуг.Ссылка В(&МассивОбъектов)";
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();	

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ТаблицаШапка = Макет.ПолучитьОбласть("ТаблицаШапка");
	Таблица = Макет.ПолучитьОбласть("Таблица");          
	ТаблицаПодвал = Макет.ПолучитьОбласть("ТаблицаПодвал");
	Подписи = Макет.ПолучитьОбласть("Подписи");   
	
	ТабличныйДокумент.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;       
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;		
		
		// заголовок
		ОбластьЗаголовок.Параметры.Номер = Выборка.Номер;
		ОбластьЗаголовок.Параметры.Дата = Формат(Выборка.Дата, "ДФ=dd.MM.yyyy");		
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);  		
		
		// шапка		
		Шапка.Параметры.Заполнить(Выборка);     
		ТабличныйДокумент.Вывести(Шапка);  	 
		
		ТабличныйДокумент.Вывести(ТаблицаШапка);  	
		
		// таблица                 
		ВыборкаУслуги = Выборка.Услуги.Выбрать();
		Пока ВыборкаУслуги.Следующий() Цикл
			Таблица.Параметры.Заполнить(ВыборкаУслуги);
			ТабличныйДокумент.Вывести(Таблица, ВыборкаУслуги.Уровень());
		КонецЦикла;  
		
		СуммаДокументаПрописью = ЧислоПрописью(Выборка.СуммаДокумента, "Л = ru_RU; ДП = Истина", "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2");
		ТаблицаПодвал.Параметры.ИтоговаяСумма = СтрШаблон("%1 (%2)", Выборка.СуммаДокумента, СуммаДокументаПрописью);
		ТабличныйДокумент.Вывести(ТаблицаПодвал);  
		
		Подписи.Параметры.Заполнить(Выборка);     
		ТабличныйДокумент.Вывести(Подписи);

		ВставлятьРазделительСтраниц = Истина;    
        // В табличном документе необходимо задать имя области, в которую был 
        // выведен объект. Нужно для возможности печати комплектов документов.
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);			
	КонецЦикла;         
	
	Возврат ТабличныйДокумент;

КонецФункции

#КонецОбласти
#КонецЕсли
