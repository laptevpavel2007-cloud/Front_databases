***1. Анализ закупки продукции**

**Основная: bm_StorageOperations**

*Данные:*

-- ID - уникальный код записи (4780421)

-- DocumentID - уникальный код документа (388235)

-- OperationID - уникальный код операции (1)

-- ProductID - уникальный код товара (4368)

-- VendorID - уникальный код поставщика (200)

-- StorageID - уникальный код склада (41)

-- Period - период в формате YYYYMM (202011)

-- Count - фактическое количество товара (2.7640)

-- Price - цена (323.00)

-- Amount - сумма закупки (892.77)

-- DateAdd - дата операции (2020-11-15 14:15:30.183)

*Связанные:*

-- product: id, description - что купили

-- vendors: id, firstname - продавец

-- vendorgroup: vendorgroupid, description - группа поставщиков

***2. Анализ продажи товара***

**Заголовки: journal**

*Данные:*

-- id - уникальный код чека (1675584)

-- dater - дата и время продажи (2020-11-15 14:15:30.183)

-- amount - итоговая сумма чека (0.00)

-- loginid - ID кассира (0.00)

-- transtype - тип операции (301)

**Строки: bm_Journal_Details**

*Данные:*

-- ID - уникальный код строки (11530445)

-- SourceID - ID заголовка чека (1675591)

-- ProductID - уникальный код товара (4407)

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

-- firstname - название контрагента (Светофор)

-- clientgroup - ID группы (31)

-- INN - реквизиты (3840001848)

-- IsUse - флаг активности (1)

**Связанные:**

-- vendorgroup: vendorgroupid, description - группа продавца

-- bm_StorageOperations: VendorID, Amount - подсчет сумм закупок

***4. Анализ работы персонала***

**Основная: personnel**

*Данные:*

-- personid - уникальный код сотрудника/рабочего места (904, 905, 906, 897)

-- lastname, firstname - ФИО или название роли/терминала (Касса 1, Кафе 2, Доставка, Администратор Barnet)

-- flagpos, flagsales - права доступа (1/0)

-- password, securityaccess - данные для авторизации

**Связанные:**

-- journal: id, amount - чеки

-- bm_JournalSessions: ID, DateAdd - смены

-- bm_JournalBarnetDocs: ID, JournalID, Period, DocumentTypeID, Amount, PersonID - документы, привязанные к сотруднику или кассе


***5. Анализ остатков***

**Основная: bm_StorageOperations**

*Данные:*

-- ProductID - ID товара

-- OperationID - 1 = приход, 2 = расход

-- Count - количество

-- DateAdd - дата операции

**Связанные:**

-- product: id, description - текущий остаток