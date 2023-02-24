### p.259 미래도시
n, m=map(int, input().split())

inf = int(1e9)
graph = [[inf]*(n+1) for _ in range(n+1)]

for _ in range(m):
    a,b=map(int, input().split())
    graph[a][b]=1
    graph[b][a]=1
    
for i in range(n+1):
    graph[i][i]=0

# 도착, 중간
x, k = map(int, input().split())

for m in range(1,n+1):
    for a in range(1,n+1):
        for b in range(1,n+1):
            graph[a][b]=min(graph[a][b],graph[a][m]+graph[m][b])
            
answer = graph[1][k]+graph[k][x]
if answer >= inf:
    answer = -1
print(answer)

### p.262 전보 ###
n,m,c = map(int,input().split())
inf = int(1e9)

time_lst = [inf]*(n+1)
graph =[[] for _ in range(n+1)]

for _ in range(m):
    start,end,cost=map(int, input().split())
    graph[start].append((end,cost))
    
from heapq import heappush, heappop

def stra(first):
    q = []
    # time, node
    heappush(q, (0, first))
    time_lst[start]=0
    
    while q:
        now_time, now = heappop(q)
        if time_lst[now] < now_time:
            continue
        for i in graph[now]:
            then_time = i[1]+now_time
            if then_time < time_lst[i[0]]:
                time_lst[i[0]]=then_time
                heappush(q, (then_time, i[0]))

stra(c)

count = 0
time_max = 0

for t in time_lst:
    if t > 0 and t < inf:
        count += 1
        if time_max < t:
            time_max = t

print(count,time_max)
            
### p.385 플로이드 ###
# https://www.acmicpc.net/problem/11404

n = int(input())
m = int(input())

inf = int(1e9)

graph = [[inf]*(n+1) for _ in range(n+1)]

for _ in range(m):
    start, end, cost = map(int, input().split())
    graph[start][end]=min(graph[start][end], cost)
    
for i in range(1, n+1):
    graph[i][i]=0

for k in range(1,n+1):
    for a in range(1,n+1):
        for b in range(1,n+1):
            graph[a][b] = min(graph[a][b],
                              graph[a][k]+graph[k][b])

for a in range(1,n+1):
    for b in range(1,n+1):
        if graph[a][b] >= inf or graph[a][b]==0:
            print(0, end=' ')
        else:
            print(graph[a][b], end= ' ')
    print()
    
### p.386 정확한 순위 
n, m = map(int, input().split())

inf = int(1e9)
graph = [[inf]*(n+1) for _ in range(n+1)]

for _ in range(m):
    a,b = map(int, input().split())
    graph[a][b]=1

for i in range(1,n+1):
    graph[i][i]=0
    
for k in range(1,n+1):
    for a in range(1,n+1):
        for b in range(1,n+1):
            graph[a][b] = min(graph[a][b], graph[a][k]+graph[k][b])

count = 0

for r in range(1,n+1):
    able = True
    for c in range(1,n+1):
        if r == c:
            continue
        elif graph[r][c] >= inf and graph[c][r] >= inf:
            able = False
            break
    if able:
        count += 1

print(count)

graph

### p.388 화성 탐사

from heapq import heappush, heappop

def stra(start, graph, cost):
    n = len(graph)
    
    r,c=start
    q = [(cost[r][c],r,c)]
    
    while q:
        # money, row, column
        m, r, c = heappop(q)
        # 처리된 적이 있다면 무시!
        if m > cost[r][c]:
            continue
        then = [(r-1,c),(r+1,c),(r,c-1),(r,c+1)]
        for nr, nc in then:
            if nr < 0  or nc < 0  or nr > n-1 or nc > n-1:
                continue
            nm = m + cost[nr][nc]
            if nm < graph[nr][nc]:
                graph[nr][nc]=nm
                heappush(q, (nm,nr,nc))

t = int(input())

for _ in range(t):
    n = int(input())
    
    inf = int(1e9)
    graph = [[inf]*n for _ in range(n)]
    
    cost = []
    for _ in range(n):
        cost.append(list(map(int, input().split())))
    
    stra((0,0),graph,cost)
    
    print(graph[n-1][n-1])

### p.390 숨바꼭질
n,m = map(int, input().split())

graph = [[] for _ in range(n+1)]

for _ in range(m):
    a,b = map(int, input().split())
    # 양방향
    graph[a].append(b)
    graph[b].append(a)
    
inf = int(1e9)
ans = [inf]*(n+1)

from heapq import heappop, heappush
def stra():
    # cost, start node
    q=[(0,1)]
    ans[1]=0
    
    while q:
        # cost, node
        c, now = heappop(q)
        if c > graph[now]:
            continue
        
        for then in graph[now]:
            if c+1 < ans[then]:
                ans[then]=c+1
                heappush(q, (c+1, then))
                
stra()

from bisect import bisect_left
idx = bisect_left(sorted(ans), inf)-1
target = sorted(ans)[idx]

print(ans.index(target), target, ans.count(target))
