from datetime import timedelta 
from faker import Faker 
import random 
import datetime 
import csv 
# Initialize Faker with Polish locale 
fake = Faker("pl_PL") 
# Helper function to generate random data 
def random_date(start_date, end_date): 
    start_date = datetime.datetime.strptime(start_date, '%Y-%m-%d').date() 
    end_date = datetime.datetime.strptime(end_date, '%Y-%m-%d').date() 
    return fake.date_between(start_date=start_date, end_date=end_date) 
# Generate data for each table (ok) 
def generate_data(): 
    # ALL NEEDED VARIABLES 
    #year_start_date, year_end_date, final_grade_start_date, current_date 
    years = [ 
        ('2017-09-26', '2018-07-01', '2018-06-24'), 
        ('2018-09-26', '2019-07-01', '2019-06-24'), 
        ('2019-09-26', '2020-07-01', '2020-06-24'), 
        ('2020-09-26', '2021-07-01', '2021-06-24'), 
        ('2021-09-26', '2022-07-01', '2022-06-24'), 
        ('2022-09-26', '2023-07-01', '2023-06-24'), 
        ('2023-09-26', '2024-07-01', '2024-06-24') 
    ] 
    current_year = ('2024-09-26', '2025-07-01', '2025-06-24', '2025-01-21') 
    year_start_date = '2024-09-26' 
    year_end_date = '2025-07-01' 
    final_grade_start_date = '2025-06-24' 
    current_date = '2025-01-23' 
    # studies and subjects 
    studies = [] 
    study_names = [ 
        "Informatyka","Matematyka", 
        "Fizyka","Biotechnologia", 
        "Inżynieria Mechaniczna","Automatyka i Robotyka", 
        "Zarządzanie","Ekonomia", 
        "Psychologia","Prawo" 
    ] 
    subjects = [] 
    subjects_names = [ 
        ["Algorytmy i Struktury Danych", "Programowanie Obiektowe", "Systemy Operacyjne", "Bazy Danych", "Sieci Komputerowe", "Sztuczna Inteligencja"], 
        ["Analiza Matematyczna", "Algebra Liniowa", "Matematyka Dyskretna", "Teoria Prawdopodobieństwa", "Równania Różniczkowe", "Metody Numeryczne"], 
        ["Mechanika Klasyczna", "Elektrodynamika", "Fizyka Kwantowa", "Termodynamika", "Fizyka Materii Skondensowanej", "Astrofizyka"], 
        ["Genetyka", "Biologia Molekularna", "Mikrobiologia", "Inżynieria Genetyczna", "Biochemia", "Bioprocesy"], 
        ["Mechanika Płynów", "Termodynamika Techniczna", "Wytrzymałość Materiałów", "Projektowanie CAD", "Mechatronika", "Materiały Inżynierskie"], 
        ["Podstawy Automatyki", "Robotyka Przemysłowa", "Systemy Wbudowane", "Sterowanie Cyfrowe", "Przetwarzanie Sygnałów", "Czujniki i Aktuatory"], 
        ["Podstawy Zarządzania", "Marketing", "Zarządzanie Projektami", "Finanse Przedsiębiorstw", "Zarządzanie Zasobami Ludzkimi", "Analiza Strategiczna"], 
        ["Mikroekonomia", "Makroekonomia", "Ekonometria", "Teoria Gier", "Polityka Ekonomiczna", "Finanse Publiczne"], 
        ["Psychologia Społeczna", "Psychologia Rozwojowa", "Psychopatologia", "Psychometria", "Kliniczne Podstawy Diagnozy", "Neuropsychologia"], 
        ["Prawo Cywilne", "Prawo Karne", "Prawo Administracyjne", "Prawo Handlowe", "Postępowanie Cywilne", "Postępowanie Karne"] ] 
    all_orders = [] 

    # 1. Employees 
    employees = [] 
    for employee_id in range(1, 101):  # ID od 1 do 100 
        first_name = fake.first_name() 
        last_name = fake.last_name() 
        email = f"{first_name.lower()}.{last_name.lower()}@example.com".replace(' ', '').replace("'", 
                                                                                                 "")  # Tworzenie maila na podstawie imienia i nazwiska 
        employees.append({ 
            "EmployeeID": employee_id, 
            "FirstName": first_name, 
            "LastName": last_name, 
            "Email": email, 
            "Phone": fake.phone_number(), 
            "EmployeeType": random.randint(1, 7)  # Typ pracownika od 1 do 7 
        }) 
    translators_id = [e["EmployeeID"] for e in employees if e["EmployeeType"] == 7] 
    coordinator_id = [e["EmployeeID"] for e in employees if e["EmployeeType"] == 3] 
    teacher_id = [e["EmployeeID"] for e in employees if e["EmployeeType"] == 3] 
    # 24. Studies 
    total_students = 0 
    studies_id_limit = [] 
    studies_fee = [] 
    for studies_id in range(1, len(study_names) + 1):  # Sequential IDs for Studies 
        studies.append({ 
            "StudiesID": studies_id, 
            "StudiesName": fake.random_element(elements=study_names),  # Randomly selected study name 
            "StudiesCoordinator": random.choice(coordinator_id), 
            "StudiesFee": round(random.uniform(3000, 10000), 2), 
            "StudiesLimit": random.choice([50, 60, 85, 100, 135]) 
        }) 
        studies_id_limit.append(studies[studies_id-1]["StudiesLimit"]) 
        studies_fee.append(studies[studies_id-1]["StudiesFee"]) 
        total_students += studies[studies_id-1]["StudiesLimit"] 
    print(total_students) 
    print(studies_id_limit) 
    print(sum(studies_id_limit)) 
    student_subject_id = [] 
    s = 1 
    for i in range(1, len(studies_id_limit)+1): 
        for j in range(0, studies_id_limit[i-1]): 
            student_subject_id.append([i, 10+i, 20+i, 30+i, 40+i, 50+i]) 
            all_orders.append(('s', i, s, studies_fee[i-1], random_date('2024-08-01' , '2024-09-01'), random_date('2024-09-01' , '2024-09-25'))) 
            s += 1  
    # 15. Subjects 
    for subject_id in range(0, len(study_names) * 6):  # Sequential IDs for Subjects 
        i = subject_id // 10 
        subjects.append({ 
            "SubjectID": subject_id + 1, 
            "StudiesID": subject_id % 10 + 1,  # Assuming 1-to-1 relationship with StudiesID 
            "CoordinatorID": random.choice(coordinator_id),  # Assuming 1-to-1 relationship with CoordinatorID 
            "SubjectName": subjects_names[subject_id % 10][i]  # Random selection from the list 
        }) 
 
    # 2. EmployeeTypes (ok) 
    employee_type_name = { 
        1: "Administrator", 
        2: "Dyrektor Szkoły", 
        3: "Koordynator", 
        4: "Wykładowca", 
        5: "Prowadzący Praktyki", 
        6: "Księgowy", 
        7: "Tłumacz" 
    } 
    employee_types = [{"EmployeeType": i, "EmployeeTypeName": name} for i, name in employee_type_name.items()] 
 
    # 3. Languages 
    languages = [ 
        {"LanguageID": 1, "LanguageName": "English"}, 
        {"LanguageID": 2, "LanguageName": "German"}, 
        {"LanguageID": 3, "LanguageName": "Spanish"}, 
        {"LanguageID": 4, "LanguageName": "French"}, 
        {"LanguageID": 5, "LanguageName": "Italian"}, 
        {"LanguageID": 6, "LanguageName": "Polish"} 
    ] 
    language_weights = [0.04, 0.04, 0.04, 0.04, 0.04, 0.80] 
    attendance_weights = [0.90, 0.10] 
    attendance = [1, 0] 
 
    # 4. Courses 
    courses = [] 
    course_names = [ 
        "Podstawy Programowania","Zaawansowane Algorytmy i Struktury Danych", 
        "Analiza Matematyczna w Praktyce", "Biotechnologia w Medycynie", 
        "Fizyka Kwantowa dla Inżynierów", "Ekonomia Środowiskowa", 
        "Zarządzanie Innowacjami", "Psychologia Motywacji i Decyzji", 
        "Podstawy Prawa Unijnego", "Inżynieria Materiałowa", 
        "Projektowanie Robotów Mobilnych", "Sieci Neuronowe i Uczenie Maszynowe", 
        "Marketing Cyfrowy i Media Społecznościowe", "Systemy Informacyjne w Zarządzaniu", 
        "Bioinformatyka i Analiza Danych Genetycznych", "Astrofizyka i Eksploracja Kosmosu", 
        "Zarządzanie Ryzykiem Finansowym", "Komunikacja Międzykulturowa w Biznesie", 
        "Prawo Ochrony Własności Intelektualnej", "Etyka w Nowoczesnej Technologii" 
    ] 
    course_types = ["online-sync", "hybrid", "in-person", "online-async"]  # Lista możliwych typów kursów 
 
    course_info = [] 
    course_limit = [] 
    for i in range(1, len(course_names)+1): 
        course_type = random.choice(course_types) # Losowy wybór z listy typów kursów 
        limit = random.choice([30, 45, 60, 90]) 
        if course_type == "online-sync" or course_type == "online-async": 
            limit = None 
        courses.append({ 
            "CourseID": i, 
            "CourseName": random.choice(course_names),  # Losowy wybór z listy nazw kursów 
            "CoursePrice": round(random.uniform(100, 1000), 2), 
            "CourseCoordinatorID": random.choice(coordinator_id), 
            "CourseType": course_type, 
            "Limit": limit }) 
        course_info.append(courses[i-1]["CoursePrice"]) 
        course_limit.append(limit) 
    # 5. CourseModules  
    course_modules = [] 
    for i in range(0, len(course_names)*3):  # Generowanie 200 modułów 
        course_modules.append({ 
            "ModuleID": i+1,  # Ciągły identyfikator modułu 
            "CourseID": i%len(course_names)+1, 
            "LanguageID": random.choices([k for k in range(1,7)], weights=language_weights, k=1)[0] }) 
    # 6. Students 
    students = [] 
    for i in range(1, total_students+1):  # Generowanie 1000 studentów 
        first_name = fake.first_name() 
        last_name = fake.last_name() 
        email = f"{first_name.lower()}.{last_name.lower()}@example.com".replace(' ', '').replace("'", 
                                                                                                 "")  # Tworzenie maila na podstawie imienia i nazwiska 
        students.append({ 
            "StudentID": i,  # Ciągły identyfikator studenta 
            "FirstName": first_name, 
            "LastName": last_name, 
            "Address": fake.address(), 
            "PostalCode": fake.zipcode(), 
            "Email": email, 
            "Phone": fake.phone_number() 
        }) 
    print(len(students)) 
    """ DODATKOWI STUDENCI """ 
    for i in range(total_students+1, total_students*len(years)+1):  # Generowanie 1000 studentów 
        first_name = fake.first_name() 
        last_name = fake.last_name() 
        email = f"{first_name.lower()}.{last_name.lower()}@example.com".replace(' ', '').replace("'", 
                                                                                                 "")  # Tworzenie maila na podstawie imienia i nazwiska 
        students.append({ 
            "StudentID": i,  # Ciągły identyfikator studenta 
            "FirstName": first_name, 
            "LastName": last_name, 
            "Address": fake.address(), 
            "PostalCode": fake.zipcode(), 
            "Email": email, 
            "Phone": fake.phone_number() 
        }) 
    """ DODATKOWI STUDENCI """ 
    # 16. Translators
    translators = [] 
    for t_id in range(1, len(translators_id) + 1):  # Sequential IDs for Translators 
        translators.append({ 
            "TranslatorID": t_id, 
            "LanguageID": fake.random_int(min=1, max=5), 
            "EmployeeID": translators_id[t_id - 1] 
        }) 
    # 12,5 StudyCongress 
    study_meetings = [] 
    meeting_names = ["nauka na kolokwium", "nauka na egzamin", "nauka na poprawke"] 
    meetings = 300 
    meeting_limits = [0] * meetings 
    meeting_subject = [0] * meetings 
    meeting_info = [] 
    study_congress = [] 
    for study_congress_id in range(1, 61): 
        date = random_date(year_start_date, year_end_date) 
        date2 = date + datetime.timedelta(days=7) 
        study_congress.append({ 
            "StudyCongressID": study_congress_id, 
            "StudiesID": (study_congress_id-1)%10 + 1, 
            "StartDate": date, 
            "EndDate": date2  }) 
        lan_tra = random.choices( 
            [{"TranslatorID": None, "LanguageID": 6, "EmployeeID": None}, random.choice(translators)], 
            weights=[0.8, 0.2], k=1) 
        limit = studies_id_limit[(study_congress_id-1)%10] 
        sub_id = random.randint(1, len(study_names) * 6) 
        meeting_limits[study_congress_id - 1] = limit 
        meeting_subject[study_congress_id - 1] = sub_id 
        study_meetings.append({ 
            "MeetingID": study_congress_id, 
            "SubjectID": study_congress_id, 
            "TeacherID": random.choice(teacher_id),  # powiazanie z wykladowcami/cw 
            "StudyCongressID": study_congress_id, 
            "MeetingName": meeting_names[random.randint(0, 2)], 
            "MeetingPrice": round(random.uniform(100, 1000), 2), 
            "Date": date, 
            "LanguageID": lan_tra[0]["LanguageID"], 
            "TranslatorID": lan_tra[0]["TranslatorID"], 
            "Limit": limit, 
            "Room": fake.word(), 
            "Video": fake.url() + str(study_congress_id), 
            "Link": fake.url() + str(study_congress_id) }) 
        meeting_info.append([study_meetings[study_congress_id - 1]["MeetingPrice"], study_meetings[study_congress_id - 1]["Date"]]) 
 
    # 13. StudyMeeting do poprawy 
    for meeting_id in range(61, meetings + 1):  # Sequential IDs for StudyMeetings 
        lan_tra = random.choices([{ "TranslatorID": None, "LanguageID": 6, "EmployeeID": None}, random.choice(translators)], weights=[0.8, 0.2], k=1) 
        limit = random.choices([35, 50, 60])[0] 
        sub_id = random.randint(1, len(study_names)*6) 
        meeting_limits[meeting_id-1] = limit 
        meeting_subject[meeting_id-1] = sub_id 
        study_meetings.append({ 
            "MeetingID": meeting_id, 
            "SubjectID": random.randint(1, len(study_names)*6), 
            "TeacherID": random.choice(teacher_id),  # powiazanie z wykladowcami/cw 
            "StudyCongressID": None, 
            "MeetingName": meeting_names[random.randint(0, 2)], 
            "MeetingPrice": round(random.uniform(100, 1000), 2), 
            "Date": random_date(year_start_date, year_end_date), 
            "LanguageID": lan_tra[0]["LanguageID"], 
            "TranslatorID": lan_tra[0]["TranslatorID"], 
            "Limit": limit, 
            "Room": fake.word(), 
            "Video": fake.url()+str(meeting_id), 
            "Link": fake.url()+str(meeting_id) }) 
        meeting_info.append([study_meetings[meeting_id-1]["MeetingPrice"], study_meetings[meeting_id-1]["Date"]]) 
 
    # 14. ModulesDetails 
    module_types = ["online-sync", "hybrid", "in-person", "online-async"] 
    modules_names = ["moduł 1", "moduł 2", "moduł 3"] 
    room_names = ["3.28", "3.29", "3.34"] 
    modules_details = [] 
    for module_id in range(1, len(course_names)*3+1):  # Sequential IDs for ModulesDetails 
        course_date = random_date(year_start_date, year_end_date) 
        modules_details.append({ 
            "ModuleID": module_id, 
            "ModuleName": modules_names[random.randint(0, 2)], 
            "Room": room_names[random.randint(0, 2)], 
            "Video": fake.url()+str(module_id), 
            "Link": fake.url()+str(module_id), 
            "DurationTime": random.choice([30, 45, 60, 90]), 
            "AccessEndDate": course_date + datetime.timedelta(days=30), 
            "CourseDate": course_date, 
            "ModuleType": random.choice(module_types) }) 
 
    # 17. Webinars 
    webinars = [] 
    webinar_names = [ 
        "Trendy w Sztucznej Inteligencji i Uczeniu Maszynowym", 
        "Jak Zbudować Skuteczny Zespół Zdalny", 
        "Psychologia w Biznesie: Motywacja i Przywództwo", 
        "Wprowadzenie do Blockchain i Kryptowalut", 
        "Optymalizacja SEO w 2024 roku", 
        "Etyka w Nowoczesnych Technologiach", 
        "Efektywne Zarządzanie Projektami Agile", 
        "Podstawy Cyberbezpieczeństwa dla Firm", 
        "Nowoczesne Techniki Rozwoju Oprogramowania", 
        "Strategie Finansowe dla Start-upów", 
        "Marketing w Mediach Społecznościowych: Najlepsze Praktyki", 
        "Podstawy Analizy Danych w Excelu", 
        "Innowacje w Biotechnologii i Medycynie", 
        "Prawo Pracy w Kontekście Zmian Cyfrowych", 
        "Jak Budować Markę Osobistą Online", 
        "Zastosowanie Internetu Rzeczy (IoT) w Przemyśle", 
        "Zaawansowane Techniki Negocjacyjne", 
        "Przyszłość E-commerce: Personalizacja i AI", 
        "Rozwój Kompetencji Miękkich w Pracy Zdalnej", 
        "Zarządzanie Ryzykiem w Świecie Dynamicznych Zmian" ] 
    webinar_info = [] 
    for webinar_id in range(1, len(webinar_names)+1):  # Sequential IDs for Webinars 
        lan_tra = random.choices( 
            [{"TranslatorID": None, "LanguageID": 6, "EmployeeID": None}, random.choice(translators)], 
            weights=[0.8, 0.2], k=1) 
        webinar_date = random_date(year_start_date, year_end_date) 
        webinars.append({ 
            "WebinarID": webinar_id, 
            "TeacherID": random.choice(teacher_id), 
            "TranslatorID": lan_tra[0]["TranslatorID"], 
            "WebinarName": random.choice(webinar_names),  # Randomly selected webinar name 
            "WebinarPrice": round(random.uniform(100, 1000), 2), 
            "LanguageID": lan_tra[0]["LanguageID"], 
            "WebinarVideoLink": fake.url()+str(webinar_id), 
            "WebinarDate": webinar_date, 
            "DurationTime": fake.random_element(elements=['1 h', '2 h', '3 h', '4 h']),  # Random duration 
            "AccessEndDate": webinar_date + datetime.timedelta(days=30), 
        }) 
        webinar_info.append([webinars[webinar_id-1]["WebinarPrice"], webinar_date, webinar_date + datetime.timedelta(days=30)]) 
 
    # 18. StudentCourses 
    student_course_attendance = [0]*len(course_names) 
    student_courses_set = set() 
    for student_courses_id in range(1, total_students+1):  # Sequential IDs for StudentCourses 
 
        c_id, std_id = random.randint(1, len(course_names)), fake.random_int(min=1, max=total_students) 
        if course_limit[c_id-1] is None or student_course_attendance[c_id-1] < course_limit[c_id-1]: 
            student_courses_set.add((c_id, std_id)) 
            all_orders.append(('c', c_id, std_id, course_info[c_id - 1], random_date('2024-08-01', '2024-09-01'), 
                           random_date('2024-09-01', '2024-09-25'))) 
            student_course_attendance[c_id - 1] += 1 
    student_courses_set = list(student_courses_set) 
    student_courses = [] 
    for record in student_courses_set:  # Sequential IDs for StudentCourses 
        student_courses.append({ 
            "CoursesID": record[0], 
            "StudentID": record[1] 
        }) 
 
    # 19. StudentModulesAttendance 
    student_modules_attendance_set = set() 
    for course_id, std_id in student_courses_set: 
        for i in range(0, 3): 
            at = random.choices(['Present', 'Absent', 'Late'], weights=[0.90, 0.05, 0.05], k=1)[0] 
 
            student_modules_attendance_set.add((i*len(course_names) + course_id, std_id, at)) 
    # forsowany jest absent jeżeli attendance modułu przekroczy limit 
    student_modules_attendance_set = list(student_modules_attendance_set) 
    student_modules_attendance = [] 
    for one, two, three in student_modules_attendance_set:  # Sequential IDs for StudentModulesAttendance 
        student_modules_attendance.append({ 
            "ModuleID": one, 
            "StudentID": two, 
            "Attendance": three 
        }) 
 
    # 20. StudentStudiesGrades 
    studies_final_grades = [] 
    cur = 0 
    for i in range(0, len(studies_id_limit)):  # Sequential IDs for StudentStudiesGrades 
        for j in range(studies_id_limit[i]): 
            cur += 1 
            studies_final_grades.append({ 
                "StudiesGradeID": i+1, 
                "StudentID": cur, 
                "FinalGrade": fake.random_int(min=2, max=5), 
                "FinalGradeDate": random_date(final_grade_start_date, year_end_date)  }) 

    # 21. StudentSubjectGrades 
    student_subject_grades = [] 
    for subject_grade_id in range(1, total_students+1):  # Sequential IDs for StudentSubjectGrades 
        for subject in range(1, 7): 
            student_subject_grades.append({ 
                "SubjectID": student_subject_id[subject_grade_id-1][subject-1], 
                "Grade": fake.random_int(min=2, max=5), 
                "StudentID": subject_grade_id  }) 
 
    # 22. StudentWebinars 
    student_webinars_set = set() 
    for webinar_attendance_id in range(1, total_students*3):  # Sequential IDs for StudentWebinarAttendance 
        w_id, std_id = random.randint(1, len(webinar_names)), fake.random_int(min=1, max=total_students) 
        student_webinars_set.add((w_id, std_id)) 
        order_date = random_date('2024-08-1', '2024-09-25') 
        # order_date = random_date('2024-09-25', webinar_info[w_id-1][1].strftime('%Y-%m-%d')) # zostawiam jakbym musiał do tego wrócić 
        all_orders.append(('w', w_id, std_id, webinar_info[w_id-1][0], order_date, random_date(order_date.strftime('%Y-%m-%d'), (order_date+datetime.timedelta(days=30)).strftime('%Y-%m-%d')))) 
 
    student_webinars_set = list(student_webinars_set) 
    student_webinars = [] 
    for one, two in student_webinars_set: 
        student_webinars.append({ 
            "WebinarID": one, 
            "StudentID": two }) 
 
    # 23. StudentMeetingAttendance 
    current_meeting = [0]*meetings 
    student_meeting_attendance_set = set() 
    meeting_orders = [[]]*meetings 
    #StudyCongressy 
    for std_id in range(1, total_students+1): 
        current_student_meetings = 0 
        for i in range(1, 61): 
            if i in student_subject_id[std_id-1]: 
                student_meeting_attendance_set.add(( 
                    i, 
                    std_id, 
                    random.choices(['Present', 'Absent', 'Late'], weights=[0.9, 0.05, 0.05], k=1)[0] 
                )) 
                current_meeting[i - 1] += 1 
                current_student_meetings += 1 
                order_date = random_date('2024-09-25', meeting_info[i-1][1].strftime('%Y-%m-%d')) 
                meeting_orders[i-1] = ('m', i, std_id, meeting_info[i-1][0] ,order_date, random_date(order_date.strftime('%Y-%m-%d'), (order_date+datetime.timedelta(days=30)).strftime('%Y-%m-%d'))) 
 
    for std_id in range(1, total_students+1): 
        current_student_meetings = 0 
        for i in range(61, meetings+1): 
            if meeting_limits[i-1] > current_meeting[i-1] and meeting_subject[i-1] in student_subject_id[std_id-1]: 
                attendance = random.choices(['Present', 'Absent', 'Late'], weights=[0.9, 0.05, 0.05], k=1)[0] 
                if meeting_info[i-1][1] > datetime.date(year=2025, month=1, day=23): 
                    attendance = 'Signed' 
                student_meeting_attendance_set.add(( 
                    i, std_id, attendance )) 
                current_meeting[i - 1] += 1 
                current_student_meetings += 1 
                #order_date = random_date('2024-09-25', meeting_info[i-1][1].strftime('%Y-%m-%d')) 
                order_date = random_date('2024-08-1', '2024-09-25') 
                meeting_orders[i-1] = ('m', i, std_id, meeting_info[i-1][0] ,order_date, random_date(order_date.strftime('%Y-%m-%d'), (order_date+datetime.timedelta(days=30)).strftime('%Y-%m-%d'))) 
            if current_student_meetings > 36: 
                break 
    for r in meeting_orders: 
        if len(r) > 5: 
            all_orders.append(r) 
 
    student_meeting_attendance_set = list(student_meeting_attendance_set) 
    student_meeting_attendance = [] 
    for one, two, three in student_meeting_attendance_set:  # Sequential IDs for MeetingDetails 
        student_meeting_attendance.append({ 
            "MeetingID": one, 
            "StudentID": two, 
            "Attendance": three }) 
 
    # 25. SubjectStudentAttendance 
    subject_student_attendance = [] 
    subject_student_attendance_set = set() 
    for i in range(0, total_students): 
        for subject_id in student_subject_id[i]: 
            for j in range(0, 6): 
                subject_student_attendance_set.add(( 
                    i+1, 
                    subject_id, 
                    random_date(year_start_date, year_end_date), 
                    #random.choices(['Present', 'Absent', 'Late'], weights=[0.9, 0.05, 0.05], k=1)[0] 
                    )) 
    subject_student_attendance_set = list(subject_student_attendance_set) 
    for one, two, three in subject_student_attendance_set: 
        attendance = random.choices(['Present', 'Absent', 'Late'], weights=[0.9, 0.05, 0.05], k=1)[0] 
        if three > datetime.date(year=2025, month=1, day= 23): 
            attendance = 'Signed' 
        subject_student_attendance.append({ 
            "StudentID": one, 
            "SubjectID": two, 
            "Date": three, 
            "Attendance": attendance  }) 
    # 26. Internships 
    internships = [] 
    # internshipy są tylko do obecnego momemntu 
    for std_id in range(1, total_students+1):  # Sequential IDs for MeetingDetails 
        start_date = random_date(year_start_date, year_end_date) 
        if start_date > datetime.date(2025, 1, 23): 
            in_st = 'pending' 
        elif start_date + datetime.timedelta(days=14) > datetime.date(2025, 1, 23): 
            in_st = 'in_progress' 
        else: 
            in_st = random.choices(['passed', 'failed'], weights=[0.90, 0.10], k=1)[0] 
        internships.append({ 
            "InternshipID": random.choice(student_subject_id[std_id-1]), 
            "StudiesID": student_subject_id[std_id-1][0], 
            "StudentID": std_id, 
            "StartDate": start_date, 
            "EndDate": start_date + datetime.timedelta(days=14), 
            "InternshipStatus": in_st 
        }) 
    print(len(all_orders)) 
    orderStatus = ["Paid", "Unpaid", "Canceled"] 
    orders = [] 
    order_details = [] 
    ordered_courses = [] 
    ordered_studies = [] 
    ordered_study_meetings = [] 
    ordered_webinars = [] 
    c_id = 1 
    for order_data in all_orders: 
        order_status = random.choices(orderStatus, weights=[0.95, 0.025, 0.025])[0] 
        paying_date = order_data[5] 
        if order_status != 'Paid': 
            paying_date = 0 
 
        orders.append({ 
            "OrderID": c_id,  # Ciągły identyfikator zamówienia 
            "StudentID": order_data[2], 
            "OrderStatus": order_status, 
            "OrderDate": order_data[4] 
        }) 
 
        if paying_date: 
            order_details.append({ 
                "OrderDetailsID": c_id, 
                "OrderID": c_id, 
                "PayingDate": paying_date 
            }) 
 
        if order_data[0] == 'c' and paying_date: 
            ordered_courses.append({ 
                "OrderDetailsID": c_id, 
                "CourseID": order_data[1], 
                "Price": order_data[3] 
            }) 
 
        if order_data[0] == 's' and paying_date: 
            ordered_studies.append({ 
                "OrderDetailsID": c_id, 
                "StudiesID": order_data[1], 
                "Price": order_data[3] 
            }) 
 
        if order_data[0] == 'm' and paying_date: 
            ordered_study_meetings.append({ 
                "OrderDetailsID": c_id, 
                "StudyMeetingID":  order_data[1], 
                "Price": order_data[3] 
            }) 
 
        if order_data[0] == 'w' and paying_date: 
            ordered_webinars.append({ 
                "OrderDetailsID": c_id, 
                "WebinarID": order_data[1], 
                "Price": order_data[3] 
            }) 
        c_id += 1 
 
    # 7. Orders 
    orders = [] 
    for i in range(1, 201):  # Generowanie 100 zamówień 
        orders.append({ 
            "OrderID": i,  # Ciągły identyfikator zamówienia 
            "StudentID": random.randint(1, 1000),  # Losowy StudentID z zakresu 1-1000 
            "OrderStatus": random.choice(orderStatus), 
            "OrderDate": random_date(year_start_date, current_date) 
        }) 
 
    # 8. OrderDetails (do poprawy) 
    order_details = [] 
    for i in range(1, 101):  # Generowanie 100 szczegółów zamówienia 
        order_details.append({ 
            "OrderDetailsID": i,  # Ciągły identyfikator OrderDetails 
            "OrderID": random.randint(1, 100),  # Losowy OrderID z zakresu 1-100 
            "PayingDate": random_date(year_start_date, current_date)  }) 
 
    # 9. OrderedCourses ok 
    ordered_courses = [] 
    for i in range(1, 51):  # Generowanie 50 zamówionych kursów 
        ordered_courses.append({ 
            "OrderDetailsID": i,  # Ciągły identyfikator CoursesOrderDetails 
            "CourseID": random.randint(1, 50),  # Losowy CourseID z zakresu 1-50 
            "Price": round(random.uniform(100, 1000), 2) 
        }) 
 
    # 10. OrderedStudies 
    ordered_studies = [] 
    for i in range(1, 26):  # Generowanie 25 zamówionych studiów 
        ordered_studies.append({ 
            "OrderDetailsID": i,  # Ciągły identyfikator OrderDetails 
            "StudiesID": random.randint(1, 50),  # Losowy StudiesID z zakresu 1-50 
            "Price": round(random.uniform(100, 1000), 2) 
        }) 
 
    # 11. OrderedStudyMeetings 
    ordered_study_meetings = [] 
    for i in range(1, 26):  # Generowanie 25 zamówionych spotkań studiów 
        ordered_study_meetings.append({ 
            "OrderDetailsID": i,  # Ciągły identyfikator StudyMeetingOrderDetails 
            "StudyMeetingID": random.randint(1, 50),  # Losowy StudyMeetingID z zakresu 1-50 
            "Price": round(random.uniform(100, 1000), 2) 
        }) 
 
    # 12. OrderedWebinars 
    ordered_webinars = [] 
    for i in range(1, 101):  # Generowanie 100 zamówionych webinarów 
        ordered_webinars.append({ 
            "OrderDetailsID": i,  # Ciągły identyfikator WebinarsOrderDetails 
            "WebinarID": random.randint(1, 50),  # Losowy WebinarID z zakresu 1-50 
            "Price": round(random.uniform(100, 1000), 2) 
        }) 
    # Return all the generated data 
    return { 
        "employees": employees, 
        "employee_types": employee_types, 
        "languages": languages, 
        "courses": courses, 
        "course_modules": course_modules, 
        "students": students, 
        "orders": orders, 
        "order_details": order_details, 
        "ordered_courses": ordered_courses, 
        "ordered_studies": ordered_studies, 
        "ordered_study_meetings": ordered_study_meetings, 
        "ordered_webinars": ordered_webinars, 
        "study_meetings": study_meetings, 
        "modules_details": modules_details, 
        "subjects": subjects, 
        "translators": translators, 
        "webinars": webinars, 
        "student_courses": student_courses, 
        "student_modules_attentandce": student_modules_attendance, 
        "studies_final_grades": studies_final_grades, 
        "student_subject_grades": student_subject_grades, 
        "student_webinars": student_webinars, 
        "student_meeting_attendance": student_meeting_attendance, 
        "studies": studies, 
        "subject_student_attendance": subject_student_attendance, 
        "internships": internships, 
        "study_congress": study_congress 
    } 
# Generate the data 
data = generate_data() 

def save_to_csv(data, filename): 
    keys = data[0].keys() 
    with open(filename, 'w', newline='', encoding='utf-8') as output_file: 
        dict_writer = csv.DictWriter(output_file, fieldnames=keys) 
        dict_writer.writeheader() 
        dict_writer.writerows(data) 

def save_all_data_to_csv(data): 
    save_to_csv(data["employees"], "Employees.csv") 
    save_to_csv(data["employee_types"], "EmployeeTypes.csv") 
    save_to_csv(data["languages"], "Languages.csv") 
    save_to_csv(data["courses"], "Courses.csv") 
    save_to_csv(data["course_modules"], "CourseModules.csv") 
    save_to_csv(data["students"], "Students.csv") 
    save_to_csv(data["orders"], "Orders.csv") 
    save_to_csv(data["order_details"], "OrderDetails.csv") 
    save_to_csv(data["ordered_courses"], "OrderedCourses.csv") 
    save_to_csv(data["ordered_studies"], "OrderedStudies.csv") 
    save_to_csv(data["ordered_study_meetings"], "OrderedStudyMeetings.csv") 
    save_to_csv(data["ordered_webinars"], "OrderedWebinars.csv") 
    save_to_csv(data["study_meetings"], "StudyMeetings.csv") 
    save_to_csv(data["modules_details"], "ModulesDetails.csv") 
    save_to_csv(data["subjects"], "Subjects.csv") 
    save_to_csv(data["translators"], "Translators.csv") 
    save_to_csv(data["webinars"], "Webinars.csv") 
    save_to_csv(data["student_courses"], "StudentCourses.csv") 
    save_to_csv(data["student_modules_attentandce"], "StudentModulesAttendance.csv") 
    save_to_csv(data["studies_final_grades"], "StudiesFinalGrades.csv") 
    save_to_csv(data["student_subject_grades"], "StudentSubjectGrades.csv") 
    save_to_csv(data["student_webinars"], "StudentWebinars.csv") 
    save_to_csv(data["student_meeting_attendance"], "StudentMeetingAttendance.csv") 
    save_to_csv(data["studies"], "Studies.csv") 
    save_to_csv(data["subject_student_attendance"], "SubjectStudentAttendance.csv") 
    save_to_csv(data["internships"], "Internships.csv") 
    save_to_csv(data["study_congress"], "StudyCongress.csv") 
# Call the function to save all data to CSV files 
save_all_data_to_csv(data) 
def save_to_csv2(data): 
    save_to_csv(data["internships"], "Internships.csv") 
# save_to_csv2(data) 
print("bazy") 