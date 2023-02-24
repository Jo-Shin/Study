### p.178 위에서 아래로 ###
N = int(input())

lst = []
for _ in range(N):
    lst.append(int(input()))
    
for x in sorted(lst, reverse=True):
    print(x, end=' ')

### p.180 성적이 낮은 순서로 학생 출력하기
N = int(input())

lst = []
for _ in range(N):
    student, score = input().split()
    lst.append([student, int(score)])

for student, score in sorted(lst, key=lambda x:x[1]):
    print(student, end=' ')
    
### p.182 두 배열의 원소 교체
N, K = list(map(int, input().split()))
A = list(map(int, input().split()))
B = list(map(int, input().split()))

A.sort()
B.sort(reverse=True)

for i in range(K):
    if A[i] < B[i]:
        A[i]=B[i]
    else:
        break

print(sum(A))

### p.359 국영수 ###
# https://www.acmicpc.net/problem/10825

N = int(input())
lst = []

for _ in range(N):
    stu, korea, eng, math = input().split()
    lst.append([stu, int(korea),int(eng),int(math)])

lst.sort(key=lambda x:(-x[1],x[2],-x[3],x[0]))

for x in lst:
    print(x[0])
    
### p.360 안테나 ###
# https://www.acmicpc.net/problem/18310

N = int(input())
lst = list(map(int, input().split()))
lst.sort()

if len(lst) % 2 == 0:
    i,j = int(len(lst)/2), int(len(lst)/2-1)
    val_i = lst[i]*i - sum(lst[:i]) + sum(lst[i+1:])-lst[i]*len(lst[i+1:])
    val_j = lst[j]*j - sum(lst[:j]) + sum(lst[j+1:])-lst[j]*len(lst[j+1:])
    if val_j <= val_i:
        print(lst[j])
    else:
        print(lst[i])
        
else:
    i = int(len(lst) // 2)
    print(lst[i])
    
### p.361 실패율 ###
https://school.programmers.co.kr/learn/courses/30/lessons/42889
    
def solution(N, stages):
    answer = []
    # 오름차순 정렬
    stages.sort()
    start = 0
    
    for stage in range(1,N+1):
        # 실패 유저 카운트
        fail = stages.count(stage)
        
        # 실패한 유저가 없거나, 도달한 유저가 없는 경우
        if fail == 0:
            answer.append([stage, 0])
            continue
        
        for i in range(start,len(stages)):
            
            # 리스트의 최댓값(마지막값)이 스테이지와 같을 경우
            # 입출력의 두번째 예시 커버
            if i == len(stages)-1 and stages[i]==stage:
                answer.append([stage,1])
            
            # 리스트 값이 스테이지보다 처음으로 커질 경우
            elif stages[i] > stage:
                # 실패율 계산
                challenger = fail + len(stages[i:])
                rate = fail / challenger
                
                # 정답 리스트 추가
                answer.append([stage, rate])
                
                # 다음 스테이지부턴 여기부터 탐색
                start = i
                break
                
    answer.sort(key=lambda x:(-x[1],x[0]))
    answer = [ans[0] for ans in answer]
        
    return answer

### p.363 카드 정렬하기 ###
# https://www.acmicpc.net/problem/1715

import heapq

N = int(input())

lst = []
for _ in range(N):
    i = int(input())
    heapq.heappush(lst, i)

answer = 0

while len(lst)>1:
    # 가장 작은 수 2개
    one = heapq.heappop(lst)
    two = heapq.heappop(lst)
    # 비교
    compare = one+two
    # 생성한 카드 묶음 리스트에 추가
    heapq.heappush(lst, compare)
    # 정답에 비교 횟수 더하기
    answer += compare
            
print(answer)
    


    

'''
1 2 3 4 5

1+2 = 3
(1+2)+3 = 6
(1+2+3)+4 = 10
(1+2+3+4)+5 = 15

1: 4 (5-1)
2: 4 (5-1)
3: 3 (5-2)
4: 2 (5-3)
5: 1 (5-4)
'''
    
