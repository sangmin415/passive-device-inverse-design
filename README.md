# Passive Device Inverse Design

> **English summary**
> Portfolio repository for my contribution to a physics-aware RF band-pass filter inverse-design study: pixel-layout generation, EMerge/Gmsh FEM simulation automation, and PBS-based large-scale dataset production. The paper configuration (25 x 25 grid, 0.4 mm/pixel) is documented separately from the later 50 x 50 random-generator implementation included in this repository.

픽셀화 RF 대역통과필터(BPF) 역설계 연구에서 제가 담당한 **레이아웃 생성, 전자기(EM) 시뮬레이션 자동화, HPC 데이터 생산 파이프라인**을 정리한 포트폴리오 저장소입니다.

논문의 AI 모델 전체를 재현하는 저장소가 아니라, 모델 학습에 필요한 구조-성능 데이터셋을 안정적으로 생성하고 검증하기 위한 구현을 중심으로 공개했습니다.

## 담당 영역

- 무작위 이진 픽셀 기반 BPF 레이아웃 생성 로직 구현
- EMerge와 Gmsh를 이용한 FEM 전자기 시뮬레이션 자동화
- 레이아웃별 S-parameter, 구조 배열, 시각화 결과 저장
- PBS 기반 배치 및 연쇄 작업 제출 스크립트 구성
- 작업별 시간 제한과 오류 격리를 적용해 일부 시뮬레이션 실패가 전체 데이터 생산을 중단하지 않도록 처리

## 연구 개요

기존 RF 필터 설계는 반복적인 EM 시뮬레이션과 설계자의 경험에 크게 의존합니다. 본 연구에서는 픽셀화된 도체 패턴과 EM 시뮬레이션으로 구조-성능 데이터셋을 구축하고, surrogate model과 역최적화를 이용해 목표 응답을 만족하는 BPF 구조를 생성했습니다.

```text
픽셀 레이아웃 생성
        ↓
Gmsh / OpenCASCADE 형상 구성
        ↓
EMerge FEM 전자기 시뮬레이션
        ↓
S-parameter · 레이아웃 이미지 · 구조 배열 저장
        ↓
역설계 모델 학습용 데이터셋
```

## 논문 기준 설계 및 검증 조건

아래 수치는 전자파학회 하계 논문에 기재된 조건과 동일합니다.

| 항목 | 논문 기준 |
|---|---:|
| 기판 크기 | 20 mm x 20 mm |
| 픽셀 설계 영역 | 10 mm x 10 mm |
| 픽셀 그리드 | 25 x 25 |
| 픽셀 크기 | 0.4 mm/pixel |
| 기판 | FR-4 |
| 기판 두께 | 1.2 mm |
| 상대유전율 | 4.0 |
| 손실탄젠트 | 0.013 |
| 도체 | Gold, 17 um |
| 목표 대역 | 5.6-7.7 GHz |
| 목표 반사손실 | -10 dB 이하 |
| 목표 삽입손실 | 약 -1.5 dB |
| EM 재검증 절대 편차 | 약 0.3 dB |
| 상대오차 | 0.93-33.21% (최소 0.93%) |

상대오차의 최대값은 논문에서 설명한 것처럼 작은 기준값에 대한 백분율 계산의 영향을 포함합니다.

## 논문 조건과 공개 코드의 관계

이 저장소에는 연구 과정의 두 구현이 함께 들어 있습니다.

| 구성 | 그리드 | 픽셀 크기 | 용도 |
|---|---:|---:|---|
| `pipelines/custom_bpf/` | 25 x 25 | 0.4 mm | 논문과 동일한 격자 조건의 지정 패턴 시뮬레이션 |
| `pipelines/random_bpf/` | 50 x 50 | 0.2 mm | 더 세밀한 격자로 확장한 후속 무작위 데이터 생성 구현 |

따라서 논문 수치와 현재 랜덤 생성 코드의 수치가 다른 것은 표기 오류가 아니라 구현 버전의 차이입니다. 각 디렉터리의 설정값은 해당 코드가 실제로 사용하는 값과 일치합니다.

## 저장소 구조

```text
passive-device-inverse-design/
├── pipelines/
│   ├── random_bpf/        # 50 x 50 무작위 레이아웃 생성 및 EM 시뮬레이션
│   └── custom_bpf/        # 25 x 25 지정 패턴 BPF 시뮬레이션
├── scripts/               # PBS 배치 및 연쇄 작업 제출 스크립트
├── requirements.txt
└── README.md
```

## 주요 구성요소

### Random BPF Pipeline

`pipelines/random_bpf/`

- `generator_new.py`: 50 x 50 확률 기반 픽셀 레이아웃 생성
- `simulation.py`: EMerge 기반 시뮬레이션 및 결과 저장
- `simulation_gmsh.py`: Gmsh 형상·메시 확인
- `simulation_pyvista.py`: PyVista 시각화
- `simulation_structure.py`: 구조 데이터 확인

```bash
cd pipelines/random_bpf
python simulation.py --seed 1
```

### Custom BPF Pipeline

`pipelines/custom_bpf/`

- 논문과 동일한 25 x 25, 0.4 mm/pixel 조건의 지정 패턴을 사용합니다.
- 원본 코드의 모듈 간 import 관계를 유지하기 위해 `Custome_*` 파일명을 보존했습니다.

```bash
cd pipelines/custom_bpf
python Custome_Simulation.py
```

### PBS/HPC Automation

`scripts/`

- `submit_batch.sh`: 여러 seed 범위를 PBS 작업으로 제출
- `run_batch.sh`: 한 작업에서 여러 seed를 순차 실행하고 timeout·실패를 개별 처리
- `run_simulation.sh`: 단일 seed 실행 후 다음 작업을 연쇄 제출
- `submit_chain.sh`: 여러 연쇄 작업의 시작점을 병렬 제출

## 시뮬레이션 설정

공개된 시뮬레이션 코드는 다음 조건으로 주파수 응답을 계산합니다.

| 항목 | 설정 |
|---|---:|
| 주파수 범위 | 0.1-30 GHz |
| 주파수 포인트 | 91 points |
| 기준 임피던스 | 50 ohm |
| 해석기 | EMerge FEM / PARDISO |
| 저장 형식 | `.s2p`, `.png`, `.npz` |

## 실행 환경

Python 의존성은 `requirements.txt`에 정리되어 있습니다.

```bash
pip install -r requirements.txt
```

실제 EM 해석에는 별도로 설치된 EMerge와 Gmsh 실행 환경이 필요합니다. PBS 스크립트는 사용하는 클러스터의 queue, conda 환경 및 프로젝트 경로에 맞게 설정해야 합니다.

## 공개 범위와 한계

- 대용량 생성 결과인 `result/`, `s2p/`, `png/`, `npz/`는 Git에서 제외했습니다.
- EMerge는 외부 해석 환경이며 본 저장소에 포함되지 않습니다.
- 연구의 전체 AI 학습·역최적화 코드는 포함하지 않고, 제가 담당한 레이아웃 및 데이터 생산 파이프라인을 중심으로 공개했습니다.
- `custom_bpf` 일부 실행 기본값에는 기존 HPC 환경 경로가 남아 있으므로 다른 환경에서는 `--output` 등 경로 설정을 변경해야 합니다.

## 관련 발표

**Physics-Aware AI-Driven Pixelated RF Band-Pass Filter Circuits Inverse Design**<br>
박강현, 범현준, 한건희, 김용모, 이상민, 박정수<br>
2026년 한국전자파학회 하계종합학술대회

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.
