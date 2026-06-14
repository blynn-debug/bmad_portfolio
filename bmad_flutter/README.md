# bmad_flutter

쇼케이스 박물관 — Flutter/iOS 학습 프로젝트. 실험실을 클리어하며 박물관 로비에 전시실을 발현시키는 수직 슬라이스 학습 앱.

## iOS 실기기 빌드 절차 (재현 가능)

App Store를 사용하지 않고(NFR1) Xcode로 iPhone 실기기에 직접 빌드한다. 한 번 셋업하면 끝까지 동일 환경에서 진행한다(NFR5).

1. iPhone을 Mac에 USB로 연결하고, 기기에서 "이 컴퓨터를 신뢰" 한다.
2. `flutter devices` 로 실기기가 인식되는지 확인한다.
3. `open ios/Runner.xcworkspace` 로 Xcode를 연다.
   - **Signing & Capabilities** 탭에서 무료 Apple 계정(Personal Team)을 선택한다.
   - 고유 Bundle ID를 설정한다: `com.sy.bmadFlutter`.
4. `flutter run -d <device-id>` 로 실행하거나, Xcode에서 직접 Run 한다.
5. 첫 설치 후 기기에서 **설정 → 일반 → VPN 및 기기 관리 → 개발자 앱 신뢰** 를 한다.

### 제약 (AR5)

- 무료 Apple 계정으로 서명한 앱은 **7일 후 만료**된다 → 만료 시 재빌드/재설치가 필요하다.
- App Store는 사용하지 않는다(NFR1).

## 개발

- 테스트: `flutter test`
- 정적 분석: `flutter analyze`
