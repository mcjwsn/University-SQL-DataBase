
---
# Podstawy baz danych


środa 16:45

nr zespołu: 3

**Autorzy:** Maciej Wiśniewski, Konrad Szymański, Kajetan Frątczak

(https://github.com/KajetanFratczak/BazyDanych24-25.git)

--- 

# 1.	Wymagania i funkcje systemu

## Funkcje Systemu

- Zlicza frekwencję użytkowników.
- Zalicza moduł prowadzony online asynchronicznie.
- Udostępnia nagranie użytkownikowi.
- Po ukończeniu webinaru i kursu online synchronicznego udostępnia użytkownikowi nagranie na okres 30 dni.
- Generuje raporty i listy na żądanie uprawnionych użytkowników:
  - Generowanie raportu finansowego.
  - Generowanie listy osób zalegających z opłatami.
  - Generowanie raportu o liczbie osób zapisanych na przyszłe wydarzenia.
  - Generowanie raportu o frekwencji.
  - Generowanie listy obecności.
  - Generowanie raportu o kolizjach użytkowników - informuje użytkownika zapisanego na dwa wydarzenia odbywające się w tym samym czasie.
- Przechowuje produkty w koszyku.
- Zapisuje wybrane produkty przez użytkownika i pozwala na płatność za wszystkie naraz.
- Weryfikuje terminowe dopłaty.
- Blokuje dostęp do kursu/studiów, jeśli użytkownik nie zapłaci 3 dni przed ich rozpoczęciem.
- Pilnuje limitów osób na kursach oraz studiach.
- Uniemożliwia dodanie użytkownika przez koordynatora przedmiotu, gdy nie ma już miejsc.
- Umożliwia zakładanie/edycję konta.
- Przechowuje dane kontaktowe.
- Przetrzymuje dane kursów, studiów, webinarów i użytkowników.

---

## Użytkownicy i funkcje jakie mogą realizować

### Użytkownicy systemu
- Uczestnik kursu (student, uczestnik kursu, uczestnik webinaru, uczestnik pojedynczego spotkania studyjnego).
- Administrator.
- Dyrektor Szkoły.
- Koordynator (studiów, przedmiotu, kursu, webinaru).
- Wykładowca.
- Prowadzący praktyki.
- Księgowy.
- Tłumacz.
- Osoba niewidniejąca w bazie (bez konta).

### Uczestnik kursu
- Zakłada konto.
- Edytuje (dane niewrażliwe, np. adres korespondencyjny)/usuwa konto.
- Zapisuje się na bezpłatne webinary.
- Zapisuje się na płatne webinary/studia/kursy/spotkania studyjne.
- Dodaje/usuwa zajęcia do/z koszyka.
- Sprawdza swój harmonogram zajęć.
- Sprawdza swoje oceny.
- Generuje raport swojej obecności na zajęciach.
- Ma dostęp do materiałów z zajęć prowadzonych online (na okres 30 dni).
- Może zrezygnować ze studiów.

### Administrator
- Modyfikuje dane użytkowników.
- Modyfikuje dane kursów, studiów i webinarów (dodawanie, usuwanie, zmiany).
- Zmienia role użytkowników systemu.
- Sprawdza harmonogram, ogólnie i poszczególnych użytkowników.
- Wprowadza zmiany do harmonogramu.

### Dyrektor Szkoły
- Sprawdza/edytuje harmonogram.
- Generuje raporty finansowe.
- Generuje, przegląda, edytuje listy użytkowników.
- Sprawdza frekwencję.
- Generuje raporty o frekwencji.
- Zarządza zaległymi płatnościami.
- Ma możliwość odroczenia płatności.

### Koordynator studiów
- Tworzy sylabus/program studiów.
- Wprowadza zmiany do harmonogramu.
- Może dodać/usunąć dodatkowych użytkowników do studiów.

### Koordynator przedmiotu
- Zalicza przedmioty studentom/wpisuje im oceny.
- Decyduje w sprawach odnośnie odrabiania.
- Tworzy spotkania studyjne.
- Generuje raport o liczbie osób zapisanych.
- Wybiera wykładowców i tłumaczy.

### Koordynator kursu
- Tworzy kurs.
- Generuje raport o liczbie osób zapisanych.
- Modyfikuje dane kursu.
- Wpisuje oceny z kursu.

### Wykładowca
- Wpisuje obecności na prowadzonych zajęciach.
- Generuje listy obecności i je modyfikuje.
- Ma dostęp do harmonogramu prowadzonych przez niego zajęć.
- Tworzy webinary i wybiera ich typ (płatny/darmowy).
- Wysyła prośby o zmianę harmonogramu (np. z powodu zdarzeń losowych).
- Wpisuje oceny z przedmiotu/kursu.

### Prowadzący praktyki
- Zalicza praktyki studentom.
- Wpisuje obecności na praktykach.
- Ma dostęp do harmonogramu prowadzonych przez niego zajęć.

### Księgowy
- Generuje raporty finansowe.
- Zwraca nadpłaty.
- Zbiera informacje o ilości zapisanych osób na przyszłe wydarzenia.

### Tłumacz
- Ma dostęp do harmonogramu zajęć nie prowadzonych po polsku.
- Wysyła prośby o zmianę harmonogramu (np. z powodu zdarzeń losowych).
- Przegląda zajęcia, które nie są prowadzone po polsku.
- Tłumaczy zajęcia na żywo.

### Osoba niewidniejąca w bazie
- Zakłada konto, dane zapisywane są do bazy.
- Przegląda dostępną ofertę.
- Ma dostęp do danych kontaktowych.

---

## Historie użytkownika

### **Historie użytkownika dla uczestnika kursu**

* Jako uczestnik webinaru/kursu/studiów chciałbym mieć możliwość zapisać się na zajęcia.  
* Jako uczestnik webinaru/kursu/studiów chciałbym mieć możliwość dostępu do materiału z poprzednich zajęć.  
* Jako uczestnik webinaru/kursu/studiów chciałbym mieć możliwość sprawdzenia swoich ocen.  
* Jako uczestnik webinaru/kursu/studiów chciałbym mieć możliwość sprawdzenia harmonogramu swoich zajęć.  
* Jako uczestnik webinaru/kursu/studiów chciałbym mieć możliwość generowania raportu obecności.  
* Jako uczestnik webinaru/kursu/studiów chciałbym mieć możliwość rezygnacji z webinaru/kursu/studiów.

### **Historie użytkownika dla administratora**

* Jako administrator chciałbym mieć możliwość modyfikacji danych użytkowników.  
* Jako administrator chciałbym mieć możliwość dodawać/usuwać użytkowników.  
* Jako administrator chciałbym mieć możliwość zmiany ról użytkowników w systemie.  
* Jako administrator chciałbym mieć możliwość wprowadzenia zmian w harmonogramie.  
* Jako administrator chciałbym mieć możliwość sprawdzenia harmonogramu dla poszczególnych użytkowników jak i dla ogółu.

### **Historie użytkownika dla Dyrektora Szkoły**

* Jako Dyrektor Szkoły chciałbym mieć możliwość generowania raportów finansowych.  
* Jako Dyrektor Szkoły chciałbym mieć możliwość edytowania harmonogramu zajęć.  
* Jako Dyrektor Szkoły chciałbym mieć możliwość zarządzania zaległymi płatnościami (odroczenia terminu, wstrzymania blokady dostępu).  
* Jako Dyrektor Szkoły chciałbym mieć możliwość przeglądania i edytowania listy użytkowników systemu.  
* Jako Dyrektor Szkoły chciałbym mieć możliwość sprawdzenia raportów o frekwencji użytkowników.

### **Historie użytkownika dla koordynatora (studiów, przedmiotu, kursu)**

* Jako koordynator chciałbym mieć możliwość tworzenia programu kursu/przedmiotu/studiów.  
* Jako koordynator chciałbym mieć możliwość uprawnienia administratora dla osób pod moją koordynacją.  
* Jako koordynator chciałbym mieć możliwość przypisania osób prowadzących zajęcia.  
* Jako koordynator chciałbym mieć możliwość przyznania stypendium.  
* Jako koordynator chciałbym mieć możliwość generować raport zapisanych osób.  
* Jako koordynator chciałbym mieć możliwość wpisania ocen.

### **Historie użytkownika dla wykładowcy**

* Jako wykładowca chciałbym mieć możliwość modyfikowania obecności na prowadzonych zajęciach.  
* Jako wykładowca chciałbym mieć możliwość dostępu do harmonogramu prowadzonych zajęć.  
* Jako wykładowca chciałbym mieć możliwość tworzenia webinarów i wybór jego typu.  
* Jako wykładowca chciałbym mieć możliwość wysłania prośby o zmianę harmonogramu.

### **Historie użytkownika dla prowadzącego praktyki**

* Jako prowadzący praktyki chciałbym mieć możliwość wpisywania obecności studentów na zajęciach praktycznych.  
* Jako prowadzący praktyki chciałbym mieć możliwość zaliczania praktyk studentom.  
* Jako prowadzący praktyki chciałbym mieć możliwość sprawdzenia harmonogramu swoich zajęć.

### **Historie użytkownika dla księgowego**

* Jako księgowy chciałbym mieć możliwość generowania raportów finansowych.  
* Jako księgowy chciałbym mieć możliwość sprawdzenia kto, a kto nie opłacił.  
* Jako księgowy chciałbym mieć możliwość zwrotu nadpłat.

### **Historie użytkownika dla tłumacza**

* Jako tłumacz chciałbym mieć możliwość przeglądania harmonogramu zajęć, które nie są prowadzone po polsku.  
* Jako tłumacz chciałbym mieć możliwość wysłania prośby o zmianę harmonogramu zajęć, które mam tłumaczyć.  
* Jako tłumacz chciałbym mieć możliwość otrzymywania materiałów do przygotowania się przed zajęciami.  
* Jako tłumacz chciałbym mieć możliwość tłumaczenia zajęć na żywo dla uczestników.

### **Historie użytkownika dla osoby niewidniejącej w bazie**

* Jako osoba niewidniejąca w bazie chciałbym mieć możliwość przeglądania dostępnej oferty kursów, webinarów i studiów.  
* Jako osoba niewidniejąca w bazie chciałbym mieć możliwość przeglądania danych kontaktowych do obsługi systemu.  
* Jako osoba niewidniejąca w bazie chciałbym mieć możliwość założenia konta w systemie, aby zapisać się na kurs/webinar.

---

## Przykładowy przypadek użycia
### Opłata za zajęcia

1. **Cel**: Opłata za zajęcia.
2. **Aktorzy systemu**:
   - Uczestnik kursu.
   - Student.
   - Członek webinaru.
3. **Scenariusz główny**:
   - Zalogowanie się na konto.
   - Wybór zajęć, za które chce zapłacić.
   - Przejście do systemu opłat.
   - Opłacanie zajęć i wyświetlenie potwierdzenia.
4. **Scenariusze alternatywne**:
   - Odrzucenie płatności, wyświetlenie informacji o niepowodzeniu płatności.


## Diagram bazy danych - wersja 1
![Diagram](diagram.png)

## Diagram bazy danych - wersja 2
![Diagram](diagram6.png)
