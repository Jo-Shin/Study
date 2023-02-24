## 그리디

### p.314 만들 수 없는 금액 ###
# ~ test-1 이하의 돈은 만들 수 있다고 정의
test = 1

N = int(input())
wallet = list(map(int, input().split()))
wallet.sort()

for coin in wallet:
    if test >= coin:
        test += coin
    else:
        break

print(test)

### 무지의 먹방 라이브 ###
import heapq

def solution(food_times, k):
    if sum(food_times) <= k:
        return -1
    
    que=[]
    for idx, food in enumerate(food_times):
        heapq.heappush(que, [food, idx+1])
        
    sum_time = 0
    pre = 0 # 초기값 설정
    
    while True:
        # 대상 선정
        now = que[0][0]
        # 소요 시간 계산 
        # 남은 음식 개수 * (소요시간 - 이전대상 소요시간)
        spend = len(que) * (now-pre)
        # k보다 크거나 같으면 합하지 않고 답 구하기
        if sum_time + spend >= k:
            jump = (k - sum_time) % len(que)
            idx_lst = sorted(que, key=lambda x:x[1])
            answer = idx_lst[jump][1]
            break
            
        else: # k보다 작으면
            sum_time += spend
            pre = heapq.heappop(que)[0]
                
    return answer
