/**
 * NPL 채권 시뮬레이션 시스템 v3.1 (Brain Upgrade Ver)
 * UI: 기존 뼈대 유지
 * Logic: 김대리 승인 검증 로직 탑재
 *
 * 출처: blynn 기존 Google Apps Script (검증 완료)
 * 용도: NPL 마켓 포트폴리오 ②축 채권계산기 로직의 원본 근거 자산.
 *      이 .gs 파일의 알고리즘을 Next.js 웹 계산기로 포팅.
 */

// ==================== [CORE] 메인 계산 함수 (로직 교체 완료) ====================
function calculateSimulation() {
  calculateSimulationSilent();
  SpreadsheetApp.getUi().alert('✅ 정밀 분석이 완료되었습니다!');
}

function calculateSimulationSilent() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('NPL 시뮬레이션');
  if (!sheet) return;

  // ---------------------------------------------------------
  // 1. 입력값 파싱 (Data Fetching)
  // ---------------------------------------------------------
  const inputs = {
    // [기초 금액]
    appraisal: parseNumber(sheet.getRange('B10').getValue()),       // 감정가
    principal: parseNumber(sheet.getRange('F10').getValue()),       // 대출원금
    unpaidInterest: parseNumber(sheet.getRange('H10').getValue()),  // 미수이자
    purchasePrice: parseNumber(sheet.getRange('J10').getValue()),   // 매입금액 (User Input)
    maxBond: parseNumber(sheet.getRange('B12').getValue()),         // 채권최고액

    // [이자율 및 비율]
    overdueRate: parseNumber(sheet.getRange('D12').getValue()) / 100,    // 연체이자율
    pledgeLoanRatio: parseNumber(sheet.getRange('F12').getValue()) / 100,// 질권대출비율
    pledgeRate: parseNumber(sheet.getRange('H12').getValue()) / 100,     // 질권대출금리

    // [비용 및 낙찰]
    taxRate: parseNumber(sheet.getRange('B16').getValue()) / 100,
    bidRate: parseNumber(sheet.getRange('F16').getValue()) / 100,
    seniorLien: parseNumber(sheet.getRange('H16').getValue()),
    auctionCost: parseNumber(sheet.getRange('J16').getValue()),
    feeRate: parseNumber(sheet.getRange('L16').getValue()) / 100,

    // [일정]
    dateContract: new Date(sheet.getRange('B18').getValue()),
    dateStart: new Date(sheet.getRange('D18').getValue()),
    dateBalance: new Date(sheet.getRange('H18').getValue()),
    dateDividend: new Date(sheet.getRange('J18').getValue())
  };

  // 2. 시간 차원 계산
  const daysInvested = (inputs.dateDividend - inputs.dateBalance) / (1000 * 60 * 60 * 24);
  const monthsInvested = daysInvested / 30.417;
  const daysInterestAccrual = (inputs.dateDividend - inputs.dateContract) / (1000 * 60 * 60 * 24);

  // 3. 지출 로직
  const rawLoanAmount = inputs.purchasePrice * inputs.pledgeLoanRatio;
  const loanAmount = Math.floor(rawLoanAmount / 1000000) * 1000000; // 100만원 단위 절사
  const legalCost = inputs.maxBond * inputs.taxRate;
  const feeCost = inputs.purchasePrice * inputs.feeRate;
  const stampTax = 0;
  const initialCost = Math.floor(legalCost + feeCost + stampTax);
  const loanInterestCost = Math.floor(loanAmount * inputs.pledgeRate * (daysInvested / 365));
  const equity = inputs.purchasePrice - loanAmount + initialCost;
  const totalExpense = inputs.purchasePrice + initialCost + loanInterestCost;

  // 4. 수입 로직 — 핵심 엔진
  const expectedBidPrice = inputs.appraisal * inputs.bidRate;
  const dividendPool = expectedBidPrice - inputs.seniorLien - inputs.auctionCost;
  const additionalInterest = inputs.principal * inputs.overdueRate * (daysInterestAccrual / 365);
  const totalClaimRaw = inputs.principal + inputs.unpaidInterest + additionalInterest;
  const finalClaim = Math.min(totalClaimRaw, inputs.maxBond); // 채권최고액 Cap
  const finalDividend = Math.max(0, Math.min(dividendPool, finalClaim));

  // 5. 수익률
  const netProfit = finalDividend - totalExpense;
  const roiPeriod = equity === 0 ? 0 : (netProfit / equity) * 100;
  const roiAnnual = daysInvested === 0 ? 0 : roiPeriod * (365 / daysInvested);
  const totalInvestedForCalc = equity + loanInterestCost;
  const roiInterestIncluded = totalInvestedForCalc === 0 ? 0 : (netProfit / totalInvestedForCalc) * 100;
  const pledgeDiff = inputs.principal - loanAmount;

  // 6. 출력 (상세 매핑은 생략 — 원본 코드 참조)
  // [요약] sheet.getRange('B22:L22') 수익률 섹션 + sheet.getRange(30+, ...) 상세 테이블
  SpreadsheetApp.flush();
}

// ==================== [샘플 데이터: 2024타경110044 동작구 신대방동] ====================
function insertSampleDataSilent() {
  // 감정가 1,720,857,880 / 원금 659,500,000 / 미수이자 74,231,030 / 매입가 686,955,110
  // 최고액 840,000,000 / 연체율 9.14% / 질권비율 75% / 질권금리 6.5%
  // 등기이전 0.5% / 낙찰예상 61% / 선순위 207,945,860 / 경매비용 7,455,110 / 수수료 0.7%
  // 계약일 2025-06-17 / 개시일 2024-05-22 / 잔금일 2025-10-30 / 배당예정 2027-02-07
}

// [UI/System 함수 원본] — onOpen, onEdit, createNPLSheet, createHeaderSection, ...
// [초기화 함수] — clearInput, clearCalculation, clearAll
// → 원본 전체는 blynn 제공 .gs 스크립트 참조. 본 파일은 Next.js 포팅용 로직 요약본.
