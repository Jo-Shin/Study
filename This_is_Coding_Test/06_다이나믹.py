### p.217 1로 만들기 ###
X = int(input())

d = [0] * (X+1)
    
for i in range(2, len(d)):
    d[i] = d[i-1]+1
    
    if i%5==0:
        d[i] = min(d[i], d[i//5]+1)

    if i%3==0:
        d[i] = min(d[i], d[i//3]+1)

    if i%2==0:
        d[i] = min(d[i], d[i//2]+1)

print(d[X])

### p.220 개미전사 ###
N = int(input())
store = list(map(int, input().split()))

d = [0] * N
d[0]=store[0]
d[1] = max(store[0],store[1])

for i in range(2, N):
    d[i]=max(d[i-1], d[i-2]+store[i])
    
print(max(d))

### p.223 바닥공사 ###
N = int(input())

d = [0]*(N+1)

d[1]=1
d[2]=3

for i in range(3,len(d)):
    d[i] = (d[i-1]+d[i-2]*2)%796796
    
print(d[N])

### p.226 효율적인 화폐 구성 ###
# 내 풀이 틀렸을 수도....
# 아이디어는 모범답안이랑 비슷함
N, M = list(map(int, input().split()))
wallet = []
for _ in range(N):
    wallet.append(int(input()))

d = [-1]*(M+1)

for i in range(1,len(d)):
    if i < min(wallet):
        continue
    elif i in wallet:
        d[i]=1
    else:
        for coin in wallet:
            if i-coin <= 0:
                continue
            elif d[i-coin] == -1:
                continue
            else:
                d[i]=d[i-coin]+1
                
print(d[M])

# 모범답안
N, M = list(map(int, input().split()))
wallet = []
for _ in range(N):
    wallet.append(int(input()))
    
d = [10001]*(M+1)

# 하기에 설명
d[0]=1

for i in range(N):
    # 동전 뽑기
    coin = wallet[i]
    for target in range(coin, M+1):
        # coin=target과 같은 경우, 1을 저장해야 함
        # 따라서 d[0]을 0으로 정의
        d[target]=min(d[target], d[target-coin]+1)
            
if d[M] == 10001:
    print(-1)
else:            
    print(d[M])
    
### p.375 금광
t = int(input())
for _ in range(t):
    n,m = map(int, input().split())
    
    raw = list(map(int, input().split()))
    
    lst = []
    for i in range(0,len(raw),m):
        lst.append(raw[i:i+m])
    
    d = [[0]*m for _ in range(n)]
    
    for c in range(m):
        for r in range(n):
            if c == 0:
                d[r][c]=lst[r][c]
            elif r == 0:
                d[r][c]=max(d[r][c-1],d[r+1][c-1]) + lst[r][c]
            elif r == n-1:
                d[r][c]=max(d[r][c-1],d[r-1][c-1]) + lst[r][c]
            else:
                d[r][c]=max(d[r][c-1],d[r-1][c-1],d[r+1][c-1]) + lst[r][c]
                
    print(max(map(max, d)))


### p.376 정수 삼각형
# https://www.acmicpc.net/problem/1932

n = int(input())
lst = [list(map(int, input().split())) for _ in range(n)]

d = [[0]*i for i in range(1,n+1)]

for r in range(n-2,-1,-1):
    for c in range(r+1):
        d[r][c] = max(d[r+1][c]+lst[r+1][c], d[r+1][c+1]+lst[r+1][c+1])

print(d[0][0]+lst[0][0])

# 다른 풀이
n = int(input())
lst = [list(map(int, input().split())) for _ in range(n)]

d = [[0]*i for i in range(1,n)]
d.append(lst[-1])

for r in range(n-2,-1,-1):
    for c in range(r+1):
        d[r][c] = max(d[r+1][c], d[r+1][c+1])+lst[r][c]

print(d[0][0])

### p.377 퇴사 ###
# https://www.acmicpc.net/problem/14501
        
N = int(input())

time = []
profit = []

for _ in range(N):
    t, p = map(int, input().split())
    time.append(t)
    profit.append(p)

# d[i]: i일 ~ 마지막날까지 벌 수 있는 최대 상담료
# 상담 종료일+1은 인덱스 N이 될 수 있으므로, N+1의 길이로 정의
d = [0]*(N+1) 
max_value = 0 # 초기값 0
        
for i in range(N-1,-1,-1):
    # i일 상담 종료일+1
    then = i + time[i]
    # 마지막 근무일(N-1)일 이후 상담 종료 시
    if then > N: 
        d[i]=max_value
    # 마지막 근무일(N-1)일 이내 상담 종료 시
    else:
        d[i]=max(profit[i]+d[then], max_value)
        max_value = d[i] # 다음 i-1일에서 사용할 비교값
        
print(max(d))

### p.380 병사 배치하기 ###
# https://www.acmicpc.net/problem/18353
# 암기 필요

N = int(input())
soldier = list(map(int, input().split()))

d = [1]*N

for i in range(N):
    for j in range(i):
        if soldier[j] > soldier[i]:
            d[i] = max(d[i], d[j]+1)

print(N-max(d))

### p.381 못생긴 수
# 어려움...
n = int(input())

ugly = [0] * n

ugly[0]=1

i2,i3,i5 = 0,0,0
next2, next3, next5 = 2,3,5

for i in range(1,n):
    ugly[i]=min(next2,next3,next5)
    
    if ugly[i]==next2:
        i2 += 1
        next2 = 2*ugly[i2]
    if ugly[i]==next3:
        i3 += 1
        next3 = 3*ugly[i3]
    if ugly[i]==next5:
        i5 += 1
        next5 = 5*ugly[i5]
        
print(ugly[-1])

### p.382 편집 거리






