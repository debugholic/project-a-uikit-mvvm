# Project A — UIKit + MVVM

[Project A-Z](#project-a-z) 의 A 단계.

여행 플래너 앱을 만들면서 한 단계마다 기술 스택을 하나씩 더해갑니다.

## 다루는 기술

- UIKit (Programmatic, Storyboard 없음)
- MVVM (View ↔ ViewModel 클로저 바인딩)

## 기능

월간 달력 + 날짜별 한 줄 메모.

## 구조

```
ProjectA/
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
└── Scenes/Calendar/
    ├── Model/CalendarDay.swift
    ├── ViewModel/CalendarViewModel.swift
    └── View/
        ├── CalendarViewController.swift
        └── CalendarDayCell.swift
```

## 빌드

Xcode 16+ / iOS 16.0+. 외부 의존성 없음.

```
open ProjectA/ProjectA.xcodeproj
```

## Project A-Z

실무에서 다뤄온 기술을 단계별로 정리하는 프로젝트입니다.

| | 추가 스택 |
|---|---|
| **A** | **UIKit + MVVM** |
| B | Diffable Data Source |
| C | Combine |
| D | async/await |
| E | Clean Architecture |
| F | XCTest |
| G | SwiftUI |
| H | SPM 모듈화 |
| I | Micro Feature Architecture |
| J | Tuist |
| K | Core Data |
| L | CloudKit |
| M | APNs |
| N | SwiftData |
| O | Objective-C + libexif |
| P | Swift Testing |
| Q | UI Test |
| R | CI/CD (GitHub Actions) |

각 단계는 별도 레포로 관리합니다.
