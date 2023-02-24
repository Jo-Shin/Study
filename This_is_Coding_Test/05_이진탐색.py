### p.197 부품 찾기 ###

N = int(input())
total = list(map(int, input().split()))

M = int(input())
target_lst = list(map(int, input().split()))

total.sort()

def bisect(array, target, start, end):
    if start > end:
        return 'no'
    
    mid = (start+end)//2
    
    if array[mid]==target:
        return 'yes'
    elif array[mid] < target:
        return bisect(array, target, mid + 1, end)
    else:
        return bisect(array, target, start, mid -1)
        
for target in target_lst:
    print(bisect(total, target, 0, N-1), end=' ')
    
### p.201 떡볶이 떡 만들기 ###
# 내 풀이
N, M = list(map(int, input().split()))
lst = list(map(int, input().split()))
lst.sort()

def bisect(array, target, start, end):
    mid = (start+end)//2
    # 찾았을 때
    if array[mid] == target:
        return mid+1
    elif array[mid] < target:
        if array[mid+1] >= target:
            return mid + 1
        else:
            start = mid + 1 
            return bisect(array, target, start, end)
    elif array[mid] > target:
        end = mid - 1
        return bisect(array, target, start, end)


for h in range(lst[N-1],-1,-1):
    if h > lst[0]:
        idx = bisect(lst,h,0,N-1)
        length = sum(lst[idx:])-h*len(lst[idx:])
    else:
        length = sum(lst)-h*len(lst)
    
    if length >= M:
        print(h)
        break

# 모범 답안 (파라메트릭 서치)
N, M = list(map(int, input().split()))
lst = list(map(int, input().split()))

start = 0
end = max(lst)

while start <= end:
    mid = (start+end) // 2
    length = 0
    for dduck in lst:
        if dduck > mid:
            length += dduck-mid
            
    if length < M:
        end = mid - 1
    elif length >= M:
        answer = mid
        start = mid + 1

print(answer)

### p.367 정렬된 배열에서 특정 수의 개수 구하기
N, x = list(map(int, input().split()))
lst = list(map(int, input().split()))

from bisect import bisect_left, bisect_right

start = bisect_left(lst,x)
end = bisect_right(lst,x) 

answer = end-start
if answer <= 0:
    answer = -1
    
print(answer)

### p.368 고정점 찾기
N = int(input())
lst = list(map(int, input().split())) # 오름차순

def bisect(lst,start, end):
    if start > end:
        return -1
    
    # 타겟이자 중간좌표
    mid = (start+end)//2
    
    if lst[mid]==mid:
        return mid
    elif lst[mid] < mid:
        start = mid + 1
        return bisect(lst, start, end)
    elif lst[mid] > mid:
        end = mid - 1
        return bisect(lst, start, end)        
    
print(bisect(lst, 0, N-1))

### 공유기 설치
# https://www.acmicpc.net/problem/2110

N, C = list(map(int, input().split()))
lst = []
for _ in range(N):
    lst.append(int(input()))
lst.sort()

# gap의 범위 [start, end]
# [1,7,8,9,10] (3개 설치)의 경우 정답이 3으로, 7-1보다 낮음
start = 1 # lst[1]-lst[0] 아님
end = lst[-1]-lst[0]

answer = 0

while start <= end:
    # gap 범위의 중점
    mid = (start+end)//2
    
    # 안테나 설치
    before_home = lst[0]
    count = 1 # 안테나
    
    for home in lst[1:]:
        if home - before_home >= mid:
            before_home = home
            count += 1
    
    if count < C:
        # 안테나 추가 설치 필요
        # gap이 작아짐
        end = mid - 1
    elif count >= C:
        # 안테나 제거 가능
        # gap이 커짐
        start = mid+1
        answer = mid
        
print(answer)

### 가사 검색 ###
# https://school.programmers.co.kr/learn/courses/30/lessons/60060
def solution(words, queries):
    
    answer = []
    
    word = [[] for _ in range(100001)]
    word_rev = [[] for _ in range(100001)]
    
    #from heapq import heappush
    for w in words:
        #heappush(word[len(w)], w)
        #heappush(word_rev[len(w)], w[::-1])
        word[len(w)].append(w)
        word_rev[len(w)].append(w[::-1])
        
    word = list(map(sorted, word))
    word_rev = list(map(sorted, word_rev))
    
    from bisect import bisect_left, bisect_right
    
    for query in queries:
        # 접두사 와일드카드
        if query[0]=='?':
            w = word_rev[len(query)] 
            
            l = bisect_left(w, query[::-1].replace('?','a'))
            r = bisect_right(w, query[::-1].replace('?','z'))
            
            answer.append(r-l)
            
        else: # 접미사 와일드카드
            w = word[len(query)]
            
            l = bisect_left(w, query.replace('?','a'))
            r = bisect_right(w, query.replace('?','z'))
            
            answer.append(r-l)
            
    return answer
