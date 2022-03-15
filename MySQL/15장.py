from tkinter import *

window = Tk()
window.mainloop()

# 라벨: 문자를 표현할 수 있는 위젯
window = Tk()

label1 = Label(window, text='test1')
label2 = Label(window, text='test2', font = ('고딕체',30), fg='blue')
label3 = Label(window, text='test3', bg='green',width=20, height=5,anchor=SE)

label1.pack() # display
label2.pack() # display
label3.pack() # display

window.mainloop()

# 버튼
def clickbutton():
    messagebox.showinfo('button click', 'this is the test')

window = Tk()
window.geometry('200x200')

button1 = Button(window, text='여기 눌러요', fg='red',bg='yellow',
                 command=clickbutton)
button1.pack(expand=1)

window.mainloop() # 가운데 정렬

# pack의 여러 기법
window = Tk()
button1 = Button(window, text='1')
button2 = Button(window, text='2')
button3 = Button(window, text='3')

button1.pack(side=LEFT) # 왼쪽부터 채움, RIGHT, TOP, BOTTOM..
button2.pack(side=LEFT)
button3.pack(side=LEFT, fill=X, padx=10, pady=10)

window.mainloop()

# 프레임, 엔트리, 리스트박스
window = Tk()
window.geometry('200x200')

up = Frame(window)
up.pack()
down = Frame(window)
down.pack()

editbox = Entry(up, width=10, bg='green') # input box
editbox.pack(padx=20, pady=20)

listbox = Listbox(down, bg='yellow')
listbox.pack()

listbox.insert(END, '하나') # 끝에서부터 넣음
listbox.insert(END, '둘')

window.mainloop()

# 메뉴
window = Tk()

mainMenu = Menu(window) # 메뉴자체 (menu bar라고 생각)
window.config(menu=mainMenu)

def func_open():
    messagebox.showinfo('제목','본문')

filemenu = Menu(mainMenu) # 상위메뉴 1
mainMenu.add_cascade(label='파일', menu=filemenu) # menu bar에 상위메뉴1 추가

filemenu.add_command(label='열기', command=func_open) # 상위메뉴1에 하위메뉴 추가
filemenu.add_separator()
filemenu.add_command(label='종료')

editmenu = Menu(mainMenu) # 상위메뉴 2
mainMenu.add_cascade(label='편집', menu=editmenu) # menu bar에 상위메뉴2 추가

editmenu.add_command(label='열기') # 상위메뉴2에 하위메뉴 추가
editmenu.add_separator()
editmenu.add_command(label='종료')

window.mainloop()

# 대화상자
from tkinter.simpledialog import *

window = Tk()
window.geometry('400x100')

label = Label(window, text='입력된 값')
label.pack()

val = askinteger('확대배수','1~6',minvalue=1,maxvalue=6)

label.configure(text=str(val))

window.mainloop()

# 캔버스
window = Tk()
canvas = Canvas(window, height=300,width=300)
canvas.pack()

# canvas.create_line(), create_polygon, create_text

!pip install pymysql
