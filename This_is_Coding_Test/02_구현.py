##### 구현 #####

### p.110 4-1 상하좌우 ### 
N = int(input())
plan = input().split()

move = ['L','R','U','D']
dr = [0,0,-1,1]
dc = [-1,1,0,0]
ㅜ
r,c=1,1

for step in plan:
    for i in range(len(move)):
        if step == move[i]:
            nr = r + dr[i]
            nc = c + dc[i]
    if nc < 1 or nr < 1 or nc > N or nr > N:
        continue
    r = nr
    c = nc
        
print(r,c)

### P.113 4-2 시각 ###
N = int(input())

minute, second = list(range(60)), list(range(60))
hour = list(range(N+1))

count = 0

for h in hour:
    for m in minute:
        for s in minute:
            if '3' in str(h) or '3' in str(m) or '3' in str(s):
                count += 1
                
print(count)

### p.115 실전2 왕실의 나이트 ###
pos = input()

c = 'abcdefgh'.find(pos[0])+1
r = int(pos[1])
    
move = [[2,1],[2,-1],[-2,1],[-2,-1],
        [1,2],[1,-2],[-1,2],[-1,-2]]
count = 0

for step in move:
    
    nr = r + step[0]
    nc = c + step[1]
    
    if nc < 1 or nr < 1 or nc > 8 or nr > 8:
        continue
    
    count += 1
            
print(count)
            
### p.119 실전3 게임 개발 ###
N,M = list(map(int, input().split()))
r,c,d=list(map(int, input().split()))

map_lst = []
for _ in range(N):
    map_lst.append(list(map(int, input().split())))

map_lst[r][c]=-1

move = [[-1,0],[0,1],[1,0],[0,-1]]
    
def turn_left(row,col,direction,move):
    # turn left
    turn_dir = direction-1
    if turn_dir < 0:
        turn_dir = 3
    
    # go (check)
    new_row = row + move[turn_dir][0]
    new_col = col + move[turn_dir][1]
    
    return new_row, new_col, turn_dir

def back(row,col,direction,move):
    new_row = row - move[direction][0]
    new_col = col - move[direction][1]
    return new_row, new_col, direction

v_count=1
d_count=0

while True:
    # 왼쪽으로 회전 후, 직진했을 시의 좌표 반환
    nr, nc, d = turn_left(r,c,d,move)
    # 회전 수 추가
    d_count+=1
                     
    if map_lst[nr][nc]==0: # 직진 시 모르는 육지
        r,c=nr,nc # 직진 완료
        v_count += 1 # 방문+1
        d_count = 0 # 회전 수 초기화
        map_lst[nr][nc] = -1 # 가본 곳으로 기록
        
    elif map_lst[nr][nc] in [-1,1]: # 직진 시 가본 육지 또는 바다
        # 만약 4회전 완료 시, 후진
        if d_count < 4:
            continue
        else: # 4회전 완료 시
            br, bc, d = back(r,c,d,move) # 후진 가정
            if map_lst[br][bc] != 1: # 후진 시 육지 일 경우
                r,c=br,bc # 후진 완료
                d_count == 0 
            elif map_lst[br][bc] == 1: # 후진 시 바다 일 경우
                break # 게임 정지
                
print(v_count)

### p.321 럭키스트레이트 ###
# https://www.acmicpc.net/problem/18406

N = list(map(int, list(input())))

half = int(len(N)/2)

a= sum(N[:half])
b= sum(N[half:])

if a == b:
    print('LUCKY')
else:
    print('READY')
    
### p.322 문자열 재정렬 ###
N = input()

word_lst = []
total = 0

for word in N:
    if word in '0123456789':
        total += int(word)
    else:
        word_lst.append(word)

ans = ''

for word in sorted(word_lst):
    ans = ans + word

print(ans+str(total))

'0123456789'[1:3:3]

### p.327 뱀 ###
# https://www.acmicpc.net/problem/3190
# 자기 자신의 몸과 부딪힌다 -> 이 조건이 이해가 안돼서 틀림
# 이해 안되면 케이스 직접 돌려보기. 그게 더 빠를 수도. 

# 지도 크기 입력
N = int(input())

# 지도 만들기    
map_lst = []
for _ in range(N):
    temp = [0]*N
    map_lst.append(temp)

# 사과 지도에 추가
# 문제에선 1행 1열이 최상단 최좌측 칸
# 파이썬에선 0행 0열이 최상단 최좌측 칸
# 따라서 입력된 사과 좌표에서 1을 빼야함
K = int(input())
for _ in range(K):
    r,c = list(map(int, input().split()))
    map_lst[r-1][c-1]=1

# 방향 전환 입력
L = int(input())

# 사전형으로 저장
# second: direction
turn_dic = dict()
for _ in range(L):
    time, direction = input().split()
    turn_dic[int(time)]=direction

# 방향 전환 및 직진 함수
def turn_dir(r,c,d,turn):
    # 북, 서, 남, 동
    move = [(-1,0),(0,-1),(1,0),(0,1)]
    
    # 왼쪽 회전
    if turn == 'L':
        nd = d+1
        if nd >= 4:
            nd = 0
    # 오른쪽 회전
    elif turn == 'D':
        nd = d-1
        if nd <= -1:
            nd = 3
    # 회전 없음
    else:
        nd = d
    
    # 직진
    nr, nc = r+move[nd][0], c+move[nd][1]
    
    return nr, nc, nd


sec = 0 # 시간(초)
r,c,d=0,0,3 # 행, 열, 방향

# 뱀이 차지하는 좌표 저장
# 머리 -> 꼬리 순
from collections import deque
snake = deque([[r,c]])

while True:
    # 방향 확인 및 직진
    nr, nc, nd = turn_dir(r,c,d,turn_dic.get(sec)) 
    sec += 1 # 시간 늘리기 
    
    # 벽
    if nr < 0  or nc < 0 or nr > N-1 or nc > N-1:
        break
    # 몸에 부딪히기
    elif [nr,nc] in snake:
        break  
    # 사과
    elif map_lst[nr][nc] == 1: 
        snake.appendleft([nr,nc]) # 머리 위치 추가
        map_lst[nr][nc]=0 # 사과 먹음
        r,c,d = nr,nc,nd # 머리 위치 변경
    # 사과 X
    elif map_lst[nr][nc] == 0:
        snake.appendleft([nr,nc]) # 머리 위치 추가
        snake.pop() # 꼬리 위치 제거(변경)
        r,c,d = nr,nc,nd # 머리 위치 변경

print(sec)

### p.329 기둥과 보 ### 
# https://school.programmers.co.kr/learn/courses/30/lessons/60061

def solution(n, build_frame):
    answer = []
    
    # 이상 점검 함수
    # 답변을 투입해서 이상 없는지 체크
    def check(ans):
        result = True # 이상 없음
         
        for x,y,thing in ans:
            if thing == 0: # 기둥
                if y == 0 or [x,y,1] in ans or [x-1,y,1] in ans or [x,y-1,0] in ans: # 이상 없음
                    continue
                else: # 이상 있음
                    result=False
                    break
            else: # 보
                # 이상 없음
                if [x,y-1,0] in ans or [x+1,y-1,0] in ans or ([x-1,y,1] in ans and [x+1,y,1] in ans):
                    continue
                else: # 이상 있음
                    result = False
                    break

        return result
    
    for build in build_frame:
        x,y,thing,action = build
        # 삭제
        if action == 0:
            temp = answer.copy()
            temp.remove([x,y,thing])
            
            if check(temp): # 이상없음
                answer = temp
            else: # 이상 있음
                continue
        # 설치
        else:
            temp = answer.copy()
            temp.append([x,y,thing])
            
            if check(temp): # 이상없음
                answer = temp
            else: # 이상 있음
                continue
        
    # 건축완료
    return sorted(answer)
             
### p.333 치킨배달 ###
# https://www.acmicpc.net/problem/15686
from itertools import combinations

N, M = list(map(int, input().split()))

town = []
for _ in range(N):
    town.append(list(map(int, input().split())))
    
home = []
chi = []
for r,lst in enumerate(town):
    for c, pos in enumerate(lst):
        if pos == 1:
            home.append([r,c])
        elif pos == 2:
            chi.append([r,c])

Choices = combinations(chi, M)

ans = 1e9
for choice in Choices:
    cit_dis = 0
    for h in home:
        chi_dis = min([abs(h[0]-c[0])+abs(h[1]-c[1]) for c in choice])
        cit_dis+=chi_dis
    if cit_dis < ans:
        ans = cit_dis
    
print(ans)


### p.335 외벽 점검 ### 
# https://school.programmers.co.kr/learn/courses/30/lessons/60062
def solution(n, weak, dist):  
    from itertools import permutations
    answer = 0
    
    weak_lst = weak + [w+n for w in weak]
    worker_permu = list(permutations(dist, len(dist)))
    
    que_lst = []
    for idx, w in enumerate(weak):
        temp = weak[idx:]+[w2+n for w2 in weak[:idx]]
        que_lst.append(temp)
    
    ans_lst = []
    for workers in worker_permu: # 작업자 순서 
        for que in que_lst: # 취약점 순서 
            start = 0 # 시작점 초기화
            count = 0 # count 초기화
            done = 0 # 완료여부 초기화
            for w in workers: # 단일 작업자 
                count += 1
                end = que[start]+w # 마무리 가능한 작업
                for i in range(start,len(que)): # 개별 취약점 검사
                    if que[i] > end: # 작업 불가능 
                        start = i # 다음 사람 시작점
                        break
                    elif que[i] <= end: # 작업 가능
                        done+=1 # 완료 업무 추가
                
                # 완료 되었을 경우
                if done == len(que):
                    ans_lst.append(count)
                    break
                                   
    if len(ans_lst) == 0:
        answer = -1
    else:
        answer = min(ans_lst)
    
    return answer
      

### p.325 도화지 만들기 ###
# https://school.programmers.co.kr/learn/courses/30/lessons/60059
def solution(key, lock):
    # 록 사이즈를 k_size-1 만큼 가로세로 키우기
    len_l = len(lock)
    len_k = len(key)
    
    # 회전 함수 (정사각 가정)
    def rotate(raw):
        new = [[0]*len(raw) for _ in range(len(raw))]
        for r in range(len(raw)):
            for c in range(len(raw)):
                new[r][c]=raw[len(raw)-1-c][r]
        return new
    
    # 도화지 만들기
    def draw(raw, len_k, len_l):
        new = [[-100]*(2*len_k-2+len_l) for _ in range(len_k-1)]
        for row in raw:
            new.append([-100]*(len_k-1)+row+[-100]*(len_k-1))
        for _ in range(len_k-1):
            new.append([-100]*(2*len_k-2+len_l))
        return new
        
    
    answer = False
    # 회전 버전마다
    for _ in range(4):
        key = rotate(key)
        # 한칸씩 상하좌우 이동
        for dr in range(len_k-1+len_l):
            for dc in range(len_k-1+len_l):
                count = 0
                temp = draw(lock, len_k, len_l)
                # 키 + 록 맞춰보기
                for r in range(len_k):
                    for c in range(len_k):
                        temp[r+dr][c+dc] = key[r][c]+temp[r+dr][c+dc]
                # 검증
                for row in temp:
                    count += row.count(1)
                    
                if count == len_l * len_l:
                    return True
                    
    return answer


### 얕은 복사 vs 깉은 복사
# https://blockdmask.tistory.com/576
# 결론: 일차원 리스트는 copy통하지만, 이차원 리스트는 copy 통하지 않는다. 
lst = [0]
a = lst
a[0]+=1
a, lst

lst = [0]
a = lst.copy()
a[0]+=1
a, lst

lst = [[0,0]]
a = lst.copy()
a[0][0]+=1
a, lst

lst = [[0,0]]
a = lst.deepcopy()
a[0][0]+=1
a, lst
