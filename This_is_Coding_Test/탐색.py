### p.149 음료수 얼려먹기 ###
N, M = list(map(int, input().split()))

# 인덱싱 오류 방지를 위해, 가장자리 추가
# 가장자리는 칸막이(1)로 취급
# 그래프
graph = [[1]*(M+2)]

for _ in range(N):
    graph.append([1] + list(map(int, list(input()))) + [1])
    
graph.append([1]*(M+2))

# 방문 여부 저장
visited = [[False]*(M+2) for _ in range(N+2)] 

def dfs(graph, r, c, visited):
    # 방문 처리
    visited[r][c]=True
    
    # 인접 노드
    Near_Nodes = [(r-1,c),(r,c-1),(r+1,c),(r,c+1)]

    for nr, nc in Near_Nodes:
        # 인접 노드가 미방문 및 얼음칸일때 탐색
        if not visited[nr][nc] and graph[nr][nc]==0:
            dfs(graph, nr, nc, visited)

count = 0 # 아이스크림 개수

# 가장자리 (0, N+1은 탐색하지 않음)
for r in range(1,N+1):
    for c in range(1,M+1):
        # 노드가 얼음칸이고, 미방문일때 탐색
        if graph[r][c]==0 and visited[r][c]==False:
            dfs(graph, r, c, visited)
            count += 1
            
print(count)

### p.152 미로 찾기 ###
from collections import deque

N, M = list(map(int, input().split()))

graph = []
for _ in range(N):
    graph.append(list(map(int, list(input()))))

# 시작 노드
queue = deque([(0,0)])

while queue:
    r,c = queue.popleft()
    then = [(r+1,c),(r,c+1),(r-1,c),(r,c-1)]

    for node in then:
        nr, nc = node
        if nr < 0 or nc < 0  or nr > N-1 or nc > M-1:
            continue
        
        if graph[nr][nc] != 0 and graph[nr][nc]==1:
            graph[nr][nc]=graph[r][c]+1
            queue.append((nr,nc))
        
print(graph[N-1][M-1])

### p.339 특정 거리의 도시 찾기 ###
# https://www.acmicpc.net/problem/18352

N, M, K, X = list(map(int, input().split()))

graph = [[] for _ in range(N+1)]
for _ in range(M):
    start, end = list(map(int, input().split()))
    graph[start].append(end)
    
visited = [0] * (N+1)

from collections import deque

def bfs(start, graph, visited):
    queue = deque([start])
    
    while queue:
        now = queue.popleft()
        for then in graph[now]:
            if visited[then] == 0 and then != start:
                visited[then] = visited[now]+1
                queue.append(then)
            elif visited[then] > 0:
                continue
            
bfs(X, graph, visited)

if visited.count(K) == 0:
    print(-1)
else:
    for node, dist in enumerate(visited):
        if dist == K:
            print(node)

### p.324 연구소 ###
# https://www.acmicpc.net/problem/14502

from collections import deque
from itertools import combinations

N, M = list(map(int, input().split()))

# 지도
graph = []
zero_count = -3 # 원래 칸 개수에서, 벽을 세개 추가로 세우므로 -3
for _ in range(N):
    value = list(map(int, input().split()))
    zero_count += value.count(0) # 0 개수 세기
    graph.append(value)

# bfs
def bfs(r,c,graph, visited, wall):
    queue = deque([(r,c)]) # 큐
    visited[r][c]=True # 시작점 방문처리
    
    # 전염 개수
    count = 0
    
    while queue:
        r,c = queue.popleft()
        # 상하좌우 이동
        then = [(r+1,c),(r,c+1),(r-1,c),(r,c-1)]
        for nr, nc in then:
            # 지도 벗어날 경우 제외
            if nr < 0 or nc < 0  or nr > N-1 or nc > M-1:
                continue
            
            # 미방문 & 벽이 아닐 경우 진출
            if not visited[nr][nc] and graph[nr][nc]!=1 and (nr,nc) not in wall:
                visited[nr][nc]=True
                if graph[nr][nc]==0:
                    count += 1 # 전염 추가
                queue.append((nr,nc))
            else:
                continue
            
    return count

wall = []

for r in range(N):
    for c in range(M):
        if graph[r][c]==0:
            wall.append((r,c))
# 세울 수 있는 벽 조합
wall_choice = list(combinations(wall,3))

ans = 0

for wall in wall_choice:# 벽 세우기
    visited = [[False]*M for _ in range(N)]
    virus_count = 0
    
    for r in range(N):
        for c in range(M):
            if graph[r][c]==2 and not visited[r][c]:            
                virus_count += bfs(r,c,graph,visited,wall)        
            else:
                continue
    
    if ans < zero_count - virus_count:
        ans = zero_count - virus_count
                
print(ans)

#### p.345 경쟁적 전염 ####
# https://www.acmicpc.net/problem/18405


#### 리트 ####

# 맵 크기, 바이러스 종류
N, K = list(map(int, input().split()))

# 맵 받기
graph = []
for _ in range(N):
    graph.append(list(map(int, input().split())))
    
# S초 후 X, Y 좌표의 바이러스는?
S, X, Y = list(map(int, input().split()))
X = X-1
Y = Y-1

# 방문여부 & 시간
visited = [[False]*N for _ in range(N)]
time = [[0]*N for _ in range(N)]

from collections import deque

def bfs(r,c, graph, visited, s):
    # 아직 돌려보지 않은 바이러스만 넣기
    q = deque([(r,c)])
    visited[r][c] = True
    
    while q:
        r, c = q.popleft()
        
        if time[r][c]==s:
            continue
                
        then = [(r+1,c),(r,c+1),(r-1,c),(r,c-1)]
        for nr, nc in then:
            # index error
            if nr < 0  or nc < 0 or nr > N-1 or nc > N-1:
                continue
            
            # 미전염 시 전염
            if graph[nr][nc]==0: # not visited[nr][nc] 
                time[nr][nc]=time[r][c]+1
                graph[nr][nc]=graph[r][c] # 전염
                visited[nr][nc]=True
                q.append((nr,nc))
                
            # 거리 같을 때, 바이러스 우등하면 전염
            elif time[nr][nc] == time[r][c]+1 and graph[nr][nc]>graph[r][c]:
                time[nr][nc]=time[r][c]+1
                graph[nr][nc]=graph[r][c] # 전염
                visited[nr][nc]=True
                q.append((nr,nc))
                
            # 거리 더 가까우면 전염
            elif time[nr][nc] > time[r][c]+1:
                time[nr][nc]=time[r][c]+1
                graph[nr][nc]=graph[r][c] # 전염
                visited[nr][nc]=True
                q.append((nr,nc))
            
for r in range(N):
    for c in range(N):
        if graph[r][c]!=0 and not visited[r][c]:
            bfs(r,c, graph, visited, S)

print(graph[X][Y])

##### 괄호변환 #####
# https://school.programmers.co.kr/learn/courses/30/lessons/60058

def solution(p):
    if p == '':
        return p 
    
    # 균형잡힌 문자열 u,v로 분할
    left = 0
    right = 0 
    
    for idx, word in enumerate(p):
        if word == '(':
            left +=1
        else:
            right +=1
        
        if left == right:
            u, v = p[:idx+1], p[idx+1:]
            break
    
    # 올바른 괄호 문자열 판단 함수 
    def check(string):
        stack = []
        
        for i in string:
            if i == '(':
                stack.append(i)
            else:
                # )가 있는데 쌍이 될 (가 없음
                if len(stack) == 0:
                    return False # 올바르지 않음
                
                # )와 쌍이 되는 (를 pop
                stack.pop()
                
        return True
    
    if check(u):
        answer = u + solution(v)
    else:
        answer = '(' + solution(v) + ')'
        for word in u[1:len(u)-1]:
            if word == '(':
                answer += ')'
            else:
                answer += '('
    return answer


##### 인구 이동 #####
# https://www.acmicpc.net/problem/16234
N,L,R = list(map(int, input().split()))
graph = [list(map(int, input().split())) for _ in range(N)]

from collections import deque

def bfs(r,c,graph,visited,L,R):
    q = deque([(r,c)])
    visited[r][c]=True
    
    nation = 0
    ppl = 0
    move_lst = [] # 연합국 좌표
    
    while q:
        r,c = q.popleft()
        ppl += graph[r][c] # 연합국민
        move_lst.append((r,c)) # 연합국가
        
        then = [(r-1,c),(r,c-1),(r+1,c),(r,c+1)] 
        
        for nr,nc in then:
            if nr < 0 or nc < 0 or nr > N-1 or nc > N-1:
                continue
            
            diff = abs(graph[r][c]-graph[nr][nc])
            if diff >= L and diff <= R and not visited[nr][nc]:
                visited[nr][nc]=True # 방문
                q.append((nr,nc))
                
    for r,c in move_lst:
        graph[r][c]=int(ppl/len(move_lst))
        
    if len(move_lst) >= 2:
        return True
    else:
        return False
        

keep = True
i = 0

while keep:
    #  방문 초기화
    visited = [[False]*N for _ in range(N)]
    keep = False
    
    for r in range(N):
        for c in range(N):
            if not visited[r][c]:
                if bfs(r,c,graph,visited,L,R):
                    keep = True 
    if keep:
        i += 1
        
print(i)

##### 감시 피하기 #####
# https://www.acmicpc.net/problem/18428

N = int(input())
graph = [list(input().split()) for _ in range(N)]

def bfs(r,c,graph): 
    N = len(graph)
    
    hide = True
    
    # 왼쪽
    for nc in sorted(range(c), reverse=True):
        if graph[r][nc]=='S':
            hide = False # 한 명이라도 발각되면 실패
            return hide
        elif graph[r][nc]=='O':
            break
    # 오른쪽
    for nc in sorted(range(c+1,N)):
        if graph[r][nc]=='S':
            hide = False
            return hide
        elif graph[r][nc]=='O':
            break
    # 북쪽
    for nr in sorted(range(r), reverse=True):
        if graph[nr][c]=='S':
            hide = False
            return hide
        elif graph[nr][c]=='O':
            break
    # 남쪽
    for nr in range(r+1,N):
        if graph[nr][c]=='S':
            hide = False
            return hide
        elif graph[nr][c]=='O':
            break
        
    return hide

# 장애물 좌표 조합 
obs_lst = []
for r in range(N):
    for c in range(N):
        if graph[r][c]=='X':
            obs_lst.append((r,c))
from itertools import combinations

obs_com = list(combinations(obs_lst,3))

# 장애물 조합 선정
for obs_set in obs_com:
    hide = True
    
    # 장애물 설치
    for r,c in obs_set:
        graph[r][c]='O'
    
    for r in range(N):
        for c in range(N):
            # 선생님일때 bfs
            if graph[r][c]=='T':
                # 한명이라도 발각되면 False
                hide = bfs(r,c,graph)
                if not hide:
                    # 실패시 다음 장애물 조합으로
                    break # 불가능
        # 실패시 다음 장애물 조합으로
        if not hide:
            break
    
    # 해당 장애물 조합으로, hide가 True유지되면 break
    if hide:
        break
    
    # 원상복구
    for r,c in obs_set:
        graph[r][c]='X'
        
if hide:    
    print('YES')
else:
    print('NO')

#### 연산자 끼워 넣기 ####

N = int(input())
num = list(map(int, input().split()))
cal_raw = list(map(int, input().split()))

temp = ['+','-','*','//']
cal = []
for i, count in enumerate(cal_raw):
    cal = cal + [temp[i]]*count

from itertools import permutations

cal = set(permutations(cal, N-1))

m = 10 ** 10
M = - 10 ** 10

for c in cal:
    result = num[0]
    for i in range(len(c)):
        if c[i] == '//' and result < 0:
            result = -1* (-1 * result // num[i+1])
        else:
            result = eval('result'+c[i]+str(num[i+1]))
    if result > M:
        M = result
    if result < m:
        m = result

print(M)s
print(m)
        
#### 로봇 이동 ####
# https://school.programmers.co.kr/learn/courses/30/lessons/60063

# 막혔던 이유
## board의 테두리에 벽을 넣을 때 잘못 설정
# board = [1]*(N+2) + [[1]+row+[1] for row in board] + [1]*(N+2)
# 이차원 배열이므로, [[1]*(N*2)] 이런식으로 이차원 처리 해줘야 함

## visit을 정의하는 데 있어서 서툴렀음
# 이처럼 시간, step을 정의할 경우, -1을 미방문, 0을 시작점, 그다음부터 +1을 해나가면됨

## 문제 제대로 안 읽음
# 가로, 세로 전후진 뿐만 아니라 평행이동도 가능함. 문제 꼭꼭!!!제대로 읽자. 

N = len(board)
board = [[1]*(N+2)] + [[1]+row+[1] for row in board] + [[1]*(N+2)]

# -1: 미방문 >=0: 방문 시점
visit_v = [[-1]*(N+2) for _ in range(N+2)]
visit_h = [[-1]*(N+2) for _ in range(N+2)]

# 좌표 기재 기준은 로봇의 최우측, 최하단
# 예를 들어, (1,2,'h')의 경우 로봇은 가로로 놓여있으며 (1,1)~(1,2)에 위치

# 가로 모드일때 가능한 이동 경우
def horizon(r,c,graph):        
    # 평행이동
    step = [(r,c-1,'h'),(r,c+1,'h'),(r+1,c,'h'),(r-1,c,'h')]
    
    # 위쪽 시계 회전
    if graph[r-1][c-1]==0:
        step.append((r,c,'v'))

    # 위쪽 반시계 회전
    if graph[r-1][c]==0:
        step.append((r,c-1,'v'))

    # 아래 시계 회전
    if graph[r+1][c]==0:
        step.append((r+1,c-1,'v'))
                    
    # 아래 반시계 회전
    if graph[r+1][c-1]==0:
        step.append((r+1,c,'v'))

    return step

# 세로일때 가능한 이동 경우
def vertical(r,c,graph):

    # 평행이동
    step = [(r+1,c,'v'),(r-1,c,'v'),(r,c+1,'v'),(r,c-1,'v')]

    # 위쪽 시계 회전
    if graph[r][c-1]==0:
        step.append((r-1,c,'h'))

    # 위쪽 반시계 회전
    if graph[r][c+1]==0:
        step.append((r-1,c+1,'h'))

    # 아래 시계 회전
    if graph[r-1][c+1]==0:
        step.append((r,c+1,'h'))

    # 아래 반시계 회전
    if graph[r-1][c-1]==0:
        step.append((r,c,'h'))

    return step

from collections import deque


# 초기 시작점(항상 가로)
q = deque([(1,2,'h')])
visit_h[1][2]=0

while q:
    r,c,d = q.popleft()
    if d =='h':
        step = horizon(r,c,board)
    elif d =='v':
        step = vertical(r,c,board)

    for then in step:
        nr,nc,nd = then
        #if nr < 1 or nc < 1 or nr > N+1 or nc > N+1:
        #    continue
        if nd == 'h':
            if visit_h[nr][nc] == -1 and board[nr][nc]==0 and board[nr][nc-1]==0:
                q.append((nr,nc,nd))
                if d == 'h':
                    visit_h[nr][nc]=visit_h[r][c]+1
                elif d =='v':
                    visit_h[nr][nc]=visit_v[r][c]+1
        elif nd == 'v':
            if visit_v[nr][nc] == -1 and board[nr][nc]==0 and board[nr-1][nc]==0:
                q.append((nr,nc,nd))
                if d == 'h':
                    visit_v[nr][nc]=visit_h[r][c]+1
                elif d =='v':
                    visit_v[nr][nc]=visit_v[r][c]+1

if visit_h[-2][-2] == -1:
    answer =  visit_v[-2][-2]
elif visit_v[-2][-2] == -1:
    answer =  visit_h[-2][-2]
else:
    answer =  min(visit_h[-2][-2],visit_v[-2][-2])
