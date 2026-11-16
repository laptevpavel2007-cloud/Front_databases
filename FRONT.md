***1. Анализ закупки продукции**

**Основная: bm_StorageOperations**

*Данные:*

-- ID - уникальный код записи (4780421)

-- DocumentID - уникальный код документа (1)

-- OperationID - уникальный код операции (1 = приход)

-- ProductID - уникальный код товара (1)

-- VendorID - уникальный код поставщика (1)

-- StorageID - уникальный код склада (1)

-- Amount - сумма закупки (892.77)

-- Price - цена (323.00)

-- Count - фактическое количество (2.7640)

-- DateAdd - дата операции (2020-11-15 14:15:30.183)

*Связанные:*

-- product: id, description - что купили

-- vendors: id, firstname - продавец

-- vendorgroup: vendorgroupid, description - группа поставщиков


***2. Анализ продажи товара***

**Заголовки: journal**

*Данные:*

-- transnumber - уникальный код транзакции (1)

-- id - строковый идентификатор (varchar)

-- dater - дата и время продажи (2020-11-15 14:15:30.183)

-- amount - итоговая сумма чека (100.000)

-- loginid - ID кассира (1)

-- transtype - тип операции (301)

**Строки: bm_Journal_Details**

*Данные:*

-- ID - уникальный код строки (11530445)

-- SourceID - ID заголовка чека (1)

-- ProductID - уникальный код товара (1)

-- Quantity - количество (1.0000)

-- Price - цена продажи (400.000)

-- sBrutto - сумма по строке (400.000)

**Связанные:**

-- product: id, description - что продали

-- transtype: transtypeid, description - типы операций

-- recipe: id, ingredientid - рецепты


***3. Анализ взаимоотношений с поставщиками***

**Основная: vendors**

*Данные:*

-- id - уникальный код (90)

-- firstname - название контрагента (ИП Габур)

-- clientgroup - ID группы (1)

-- INN - реквизиты (3840001848)

**Связанные:**

-- vendorgroup: vendorgroupid, description - группа продавца

-- bm_StorageOperations: VendorID, Amount - подсчет сумм закупок

***4. Анализ работы персонала***

**Основная: personnel**

*Данные:*

-- personid - уникальный код сотрудника (905)

-- lastname, firstname, middlename - ФИО или роль (Кафе 2, Касса 2)

-- flagpos, flagsales - права доступа (1/0)

**Связанные:**

-- journal: id, amount - чеки

-- bm_JournalSessions: ID, DateAdd - смены

-- bm_JournalBarnetDocs: ID, JournalID, Period, DocumentTypeID, Amount, PersonID - документы, привязанные к сотруднику или кассе


***5. Анализ остатков***

**Основная: bm_StorageOperations**

*Данные:*

-- ID - уникальный код записи (4780421)

-- ProductID - ID товара (FK на product.id)

-- OperationID - тип операции (1/2)

-- Count - количество (2.7640)

-- StorageID - ID склада (1)

-- DateAdd - дата операции (2020-11-15 14:15:30.183)

**Связанные:**

-- product: id, description - текущий остаток
-- storages - справочник складов