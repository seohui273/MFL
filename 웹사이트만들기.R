library(shiny)
library(bslib)

# 1. 패키지 설치 및 로드
if (!require("rsconnect")) install.packages("rsconnect")
library(rsconnect)

# 2. 계정 정보 입력 (본인의 정보로 수정)
rsconnect::setAccountInfo(name='jbnu2026mfl', 
                          token='341F256ABB7E0CBF9D25107571CEE35D', 
                          secret='uqzaCEbyu/5KXJ32l0W30ybg5zyKp4cjoTi66yf8')

# 3. 배포 (현재 폴더의 내용을 서버로 전송)
rsconnect::deployApp(".")
# ==========================================
# 1. UI (User Interface)
# ==========================================
ui <- navbarPage(
  id = "main_navbar",
  title = div(
    style = "display: flex; align-items: center; gap: 15px;",
    # 사이드 디렉토리 토글 버튼
    tags$button(
      "☰", 
      class = "menu-toggle-btn", 
      onclick = "document.getElementById('sidePanel').classList.toggle('open');"
    ),
    span("MFL", style = "font-weight: 800; letter-spacing: 2px; color: #F59E0B; font-size: 1.2rem; font-family: 'Montserrat', sans-serif;"),
    span("×", style = "color: rgba(255, 255, 255, 0.3); font-weight: 300; font-size: 1rem;"),
    span("Market Frontier Lab", style = "font-weight: 600; color: #FFFFFF; font-size: 0.85rem; letter-spacing: 1.5px; text-transform: uppercase; opacity: 0.9; font-family: 'Montserrat', sans-serif;")
  ),
  
  # 전북대 MFL 정체성에 맞춘 테마 커스텀 (다크네이비 & 소프트그레이 기반)
  theme = bs_theme(
    version = 5,
    bg = "#F8FAFC",         # 부드러운 소프트 그레이 슬레이트 배경
    fg = "#1E293B",         # 가독성 높은 다크 슬레이트 폰트
    primary = "#0F172A",    # 메인 브랜드 컬러 (헤더 및 주요 버튼용 다크 네이비)
    secondary = "#2563EB"   # 포인트 컬러 (블루)
  ),
  
  header = tags$head(
    tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
    tags$link(rel = "preconnect", href = "https://fonts.gstatic.com", crossorigin = NA),
    tags$link(rel = "stylesheet",
              href = "https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700;800&family=Pretendard:wght@300;400;500;600;700&family=IBM+Plex+Mono:wght@400;500&display=swap"),
    tags$style(HTML("
      /* 全局 리셋 및 기반 폰트 최적화 */
      *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
      html, body {
        background-color: #F8FAFC !important;
        color: #1E293B !important;
        font-family: 'Pretendard', sans-serif !important;
        -webkit-font-smoothing: antialiased;
      }

      /* 내비게이션 바 스타일 고도화 (Tailwind Backdrop blur 반영) */
      .navbar {
        background: rgba(15, 23, 42, 0.95) !important; /* 세련된 다크네이비 상단바 */
        backdrop-filter: blur(12px) !important;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1) !important;
        padding: 14px 40px !important;
      }
      .navbar-nav .nav-link {
        color: rgba(255, 255, 255, 0.7) !important;
        font-size: 0.85rem !important;
        font-weight: 600 !important;
        letter-spacing: 1px !important;
        padding: 8px 20px !important;
        transition: all 0.25s ease !important;
      }
      .navbar-nav .nav-link:hover,
      .navbar-nav .nav-link.active {
        color: #F59E0B !important; /* 활성화 시 앰버 골드 포인트 */
        background: rgba(255, 255, 255, 0.08) !important;
        border-radius: 8px;
      }

      /* 목차 세 줄 토글 버튼 */
      .menu-toggle-btn {
        background: none; border: none; font-size: 1.4rem; color: #F59E0B; cursor: pointer; padding: 0 5px;
        display: flex; align-items: center; transition: transform 0.2s ease;
      }
      .menu-toggle-btn:hover { transform: scale(1.1); }

      /* HTML 연동 사이드 패널 슬라이드 */
      .side-panel-wrapper {
        position: fixed; top: 0; left: -300px; width: 300px; height: 100%;
        background: #0F172A; box-shadow: 6px 0 30px rgba(0,0,0,0.3);
        transition: left 0.4s cubic-bezier(0.16, 1, 0.3, 1); z-index: 2000;
        padding: 40px 24px; border-right: 1px solid rgba(255,255,255,0.1);
      }
      .side-panel-wrapper.open { left: 0; }
      .side-panel-close {
        position: absolute; top: 20px; right: 20px; background: none; border: none;
        font-size: 1.3rem; cursor: pointer; color: #94A3B8;
      }
      .side-panel-title {
        font-family: 'Montserrat', sans-serif; font-weight: 700; font-size: 1.1rem;
        color: #F59E0B; margin-bottom: 35px; padding-bottom: 12px; border-bottom: 2px solid #F59E0B;
        letter-spacing: 1px;
      }
      .side-menu-item {
        padding: 14px 18px; font-size: 0.9rem; font-weight: 500; color: #CBD5E1;
        cursor: pointer; border-radius: 10px; margin-bottom: 10px; transition: all 0.2s ease;
      }
      .side-menu-item:hover { background: rgba(255, 255, 255, 0.08); color: #FFFFFF; }

      /* 깔끔한 사각형 테두리 버튼 디자인 (통일 요건 반영) */
      .outline-navy-btn {
        background-color: #FFFFFF !important;
        color: #0F172A !important;
        border: 2px solid #0F172A !important;
        border-radius: 8px !important;
        font-size: 0.85rem !important;
        font-weight: 700 !important;
        letter-spacing: 1px !important;
        padding: 10px 24px !important;
        box-shadow: none !important;
        transition: all 0.2s ease-in-out !important;
      }
      .outline-navy-btn:hover {
        background-color: #0F172A !important;
        color: #FFFFFF !important;
        transform: translateY(-1px);
      }

      /* 메인 컨테이너 정밀 규격 */
      .container-fluid { padding: 0 40px !important; max-width: 1280px; margin: 0 auto; }

      /* HTML 템플릿 감성을 담은 프리미엄 히어로 섹션 */
      .hero-section {
        position: relative; padding: 80px 60px; border-radius: 24px; margin: 32px 0 40px; overflow: hidden;
        background: radial-gradient(circle at 80% 20%, rgba(37, 99, 235, 0.15) 0%, transparent 50%),
                    linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
        border: 1px solid rgba(255,255,255,0.08);
        box-shadow: 0 20px 40px rgba(15,23,42,0.08);
      }
      .hero-eyebrow {
        display: inline-block; bg-color: rgba(37,99,235,0.1); color: #3B82F6;
        font-family: 'Montserrat', sans-serif; font-weight: 700; font-size: 0.75rem;
        letter-spacing: 2px; padding: 6px 16px; border-radius: 100px; margin-bottom: 20px;
        background: rgba(37, 99, 235, 0.1); border: 1px solid rgba(37, 99, 235, 0.2);
      }
      .hero-title {
        font-size: clamp(2.2rem, 4vw, 3.2rem); color: #FFFFFF; font-weight: 900;
        line-height: 1.25; margin-bottom: 16px; letter-spacing: -0.5px;
      }
      .hero-title .accent {
        color: transparent; background-clip: text;
        background-image: linear-gradient(to right, #3B82F6, #6366F1);
      }
      .hero-subtitle { font-size: 1rem; color: #94A3B8; max-width: 600px; font-weight: 400; line-height: 1.7; }
      .hero-tags { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 32px; }
      .hero-tag.gold { background: rgba(245,158,11,0.1); border: 1px solid rgba(245,158,11,0.3); color: #F59E0B; border-radius: 8px; padding: 6px 14px; font-size: 0.75rem; font-weight: 600;}
      .hero-tag.ghost { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); color: #94A3B8; border-radius: 8px; padding: 6px 14px; font-size: 0.75rem;}

      /* 대시보드 스탯 카드 스타일 */
      .stat-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 40px; }
      @media(max-width:768px) { .stat-grid { grid-template-columns: 1fr; } }
      .stat-card { border-radius: 20px; padding: 26px 28px; background: #FFFFFF; border: 1px solid #E2E8F0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); }
      .stat-card.accent-card { border-left: 4px solid #2563EB; }
      .stat-label { font-size: 0.8rem; font-weight: 600; color: #64748B; margin-bottom: 10px; }
      .stat-value { font-family: 'Montserrat', sans-serif; font-size: 1.8rem; font-weight: 800; color: #0F172A; }

      /* 스마트 캘린더 그리드 시스템 */
      .calendar-container { background: #FFFFFF; border: 1px solid #E2E8F0; border-radius: 20px; padding: 28px; box-shadow: 0 4px 12px rgba(0,0,0,0.01); }
      .calendar-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 8px; margin-top: 20px; }
      .calendar-header-day { text-align: center; font-weight: 700; font-size: 0.78rem; padding: 10px; background: #0F172A; color: #FFFFFF; border-radius: 6px; }
      .calendar-day-box { background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 8px; min-height: 100px; padding: 8px; display: flex; flex-direction: column; gap: 6px; }
      .calendar-day-num { font-family: 'IBM Plex Mono', monospace; font-size: 0.8rem; font-weight: 600; color: #64748B; }
      .calendar-schedule-item { font-size: 0.72rem; background: rgba(37,99,235,0.08); color: #1D4ED8; padding: 4px 8px; border-left: 3px solid #2563EB; border-radius: 4px; font-weight: 500; word-break: break-all; }

      /* 활동기록 사이드바 및 피드 아카이브 */
      .sidebar-panel-custom { background: #0F172A !important; border-radius: 20px !important; padding: 28px !important; color: #FFFFFF; border: none !important; }
      .form-label { font-size: 0.78rem !important; font-weight: 600 !important; color: #94A3B8 !important; margin-bottom: 6px !important; }
      .form-control, .form-select { background: rgba(255,255,255,0.07) !important; border: 1px solid rgba(255,255,255,0.1) !important; border-radius: 10px !important; color: #FFFFFF !important; font-size: 0.88rem !important; }
      .form-control:focus, .form-select:focus { border-color: #2563EB !important; box-shadow: none !important; }
      
      .feed-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid #E2E8F0; }
      .feed-title { font-size: 1.4rem; font-weight: 800; color: #0F172A; }
      .post-card { background: #FFFFFF; border: 1px solid #E2E8F0; border-radius: 16px; padding: 24px; margin-bottom: 16px; box-shadow: 0 4px 6px rgba(0,0,0,0.01); transition: transform 0.2s; }
      .post-card:hover { transform: translateY(-2px); }
      .post-card-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; }
      .post-card-title { font-size: 1.15rem; font-weight: 700; color: #0F172A; }
      .post-tag-badge { font-size: 0.7rem; font-weight: 600; padding: 4px 12px; border-radius: 100px; background: rgba(37,99,235,0.1); color: #2563EB; }
    ")),
    
    tags$script(HTML("
      document.addEventListener('paste', function(e) {
        var items = e.clipboardData.items;
        for (var i = 0; i < items.length; i++) {
          if (items[i].type.indexOf('image') !== -1) {
            var blob = items[i].getAsFile();
            var reader = new FileReader();
            reader.onload = function(event) {
              Shiny.setInputValue('pasted_image', event.target.result, {priority: 'event'});
            };
            reader.readAsDataURL(blob);
          }
        }
      });
      function closeSidePanel() { document.getElementById('sidePanel').classList.remove('open'); }
    "))
  ),
  
  # ── HTML 구조 연동 슬라이드 메뉴 패널 ──
  tags$div(
    id = "sidePanel", class = "side-panel-wrapper",
    tags$button("✕", class = "side-panel-close", onclick = "closeSidePanel();"),
    div("MFL DIRECTORY", class = "side-panel-title"),
    div("📅 활동소개 (메인 캘린더)", class = "side-menu-item", onclick = "Shiny.setInputValue('menu_select', '활동소개'); closeSidePanel();"),
    div("📂 활동기록 (아카이브 피드)", class = "side-menu-item", onclick = "Shiny.setInputValue('menu_select', '활동기록'); closeSidePanel();"),
    div("✉️ 가입안내 (지원정보)", class = "side-menu-item", onclick = "Shiny.setInputValue('menu_select', '가입안내'); closeSidePanel();")
  ),
  
  # ──────────────────────────────────────────
  # 탭 1: 활동소개 (메인 & 캘린더)
  # ──────────────────────────────────────────
  tabPanel("활동소개",
           fluidPage(
             style = "padding-top: 0; padding-bottom: 60px;",
             
             # 고도화된 프리미엄 히어로 배너 (HTML 디자인 자산 결합)
             div(class = "hero-section",
                 div(class = "hero-eyebrow", "JBNU CAREER INVESTIGATION CLUB"),
                 h1(class = "hero-title", "기업을 분석하고, 현장을 탐방하며,", br(), tags$span(class = "accent", "실무 감각을 키우는 MFL")),
                 p(class = "hero-subtitle", "Market Frontier Lab은 전북대학교 학생들이 데이터 기반 기업 분석, 가상기업 제작, 거시 데이터 리서치를 통해 실무 중심적 시장 통찰력을 기르는 학술 취업동아리입니다."),
                 div(class = "hero-tags",
                     span(class = "hero-tag gold", "📊 통계학 · 경제학 리서치"),
                     span(class = "hero-tag ghost", "💡 DRIP 프레임워크"),
                     span(class = "hero-tag ghost", "📋 ADsP / 사회조사분석사")
                 )
             ),
             
             # 실시간 싱크 스탯 그리드
             div(class = "stat-grid",
                 div(class = "stat-card accent-card",
                     div(class = "stat-label", "누적 데이터 처리 건수"),
                     div(class = "stat-value", "4,425+ 건"),
                     div(style="font-size:0.75rem; color:#94A3B8; margin-top:6px;", "Real-estate Transaction Records")
                 ),
                 div(class = "stat-card",
                     div(class = "stat-label", "핵심 직무 자격증"),
                     div(class = "stat-value", "ADsP / 사조사 2급"),
                     div(style="font-size:0.75rem; color:#94A3B8; margin-top:6px;", "Data Analytics Track")
                 ),
                 div(class = "stat-card",
                     div(class = "stat-label", "공모전 성과"),
                     div(class = "stat-value", "최우수상 포함 5회"),
                     div(style="font-size:0.75rem; color:#94A3B8; margin-top:6px;", "한전KDN 국민제안 혁신 최우수")
                 )
             ),
             
             # 활동 캘린더 세션
             div(class = "calendar-container",
                 h3(style="font-weight:800; color:#0F172A; margin-bottom:4px;", "📅 MFL 활동 캘린더"),
                 p(style="font-size:0.88rem; color:#64748B; margin-bottom:24px;", "정기 리서치 및 학술 프로젝트 일정을 등록하고 공유하는 스마트 보드입니다."),
                 
                 div(style = "display: flex; gap: 12px; flex-wrap: wrap; align-items: flex-end; background: #F8FAFC; padding: 20px; border-radius: 12px; margin-bottom: 24px; border: 1px solid #E2E8F0;",
                     div(style = "width: 120px;",
                         selectInput("cal_day", "날짜 선택", choices = setNames(1:28, paste0(1:28, "일")), width = "100%")
                     ),
                     div(style = "flex: 1; min-width: 250px;",
                         textInput("cal_text", "일정 내용 입력", placeholder = "예: 거시경제 금융 데이터 분석 세션", width = "100%")
                     ),
                     actionButton("add_cal_btn", "일정 추가", class = "outline-navy-btn")
                 ),
                 
                 uiOutput("rendered_calendar")
             )
           )
  ),
  
  # ──────────────────────────────────────────
  # 탭 2: 활동기록 (상/하반기 아카이브 고도화)
  # ──────────────────────────────────────────
  tabPanel("활동기록",
           fluidPage(
             style = "padding-top: 32px; padding-bottom: 60px;",
             
             sidebarLayout(
               sidebarPanel(
                 class = "sidebar-panel-custom", width = 4,
                 div(style="font-family:'Montserrat',sans-serif; font-weight:700; font-size:1.2rem; color:#F59E0B;", "ARCHIVE TRACKER"),
                 p(style="font-size:0.8rem; color:#94A3B8; margin-bottom:20px;", "새로운 실무 및 연구 기록을 보관합니다."),
                 
                 div(style = "margin-bottom: 16px;",
                     tags$label("활동 대주제", class = "form-label"),
                     textInput("post_title", label = NULL, placeholder = "예: R Shiny 포트폴리오 최적화 프로젝트")
                 ),
                 div(style = "margin-bottom: 16px;",
                     tags$label("기록 일자 및 분기 선택", class = "form-label"),
                     selectInput("post_half", label = NULL, choices = c("2026년 상반기" = "first", "2026년 하반기" = "second"))
                 ),
                 div(style = "margin-bottom: 16px;",
                     tags$label("기록 멤버 및 팀명", class = "form-label"),
                     textInput("post_author", label = NULL, placeholder = "예: 최서희 (리서치팀)")
                 ),
                 div(style = "margin-bottom: 16px;",
                     tags$label("카테고리 분류", class = "form-label"),
                     selectInput("post_tag", label = NULL, choices = c("활동기록", "공모전 리포트", "기업 및 현장탐방", "오픽/실무 스터디"))
                 ),
                 div(style = "margin-bottom: 12px;",
                     tags$label("상세 활동 기록내용", class = "form-label"),
                     textAreaInput("post_content", label = NULL, placeholder = "내용을 요약 입력하세요. (스크린샷 이미지는 인풋창 클릭 후 Ctrl+V 가능)", rows = 5)
                 ),
                 uiOutput("pasted_img_preview"),
                 br(),
                 actionButton("submit_post", "아카이브 저장하기", class = "outline-navy-btn", style="width:100% !important; background-color:#F59E0B !important; color:#0F172A !important; border:none !important;")
               ),
               
               mainPanel(
                 width = 8, style = "padding-left: 28px;",
                 div(class = "feed-header",
                     div(class = "feed-title", "MFL Activity Archive"),
                     div(style="font-family:'Montserrat',sans-serif; font-weight:700; color:#2563EB;", "2026 TIMELINE FEED")
                 ),
                 
                 # 상반기 / 하반기 분리 탭셋 고도화 연동
                 navset_underline(
                   nav_panel("2026년 상반기", 
                             div(style = "padding-top:24px;"),
                             uiOutput("news_feed_first")
                   ),
                   nav_panel("2026년 하반기", 
                             div(style = "padding-top:24px;"),
                             uiOutput("news_feed_second")
                   )
                 )
               )
             )
           )
  ),
  
  # ──────────────────────────────────────────
  # 탭 3: 가입안내
  # ──────────────────────────────────────────
  tabPanel("가입안내",
           fluidPage(
             style = "padding-top: 0; padding-bottom: 80px;",
             div(style = "position: relative; padding: 70px 50px; border-radius: 24px; margin: 32px 0 40px; background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%); border: 1px solid rgba(255,255,255,0.05);",
                 h1(style = "font-weight:800; color:#FFFFFF; margin-bottom:12px;", "함께 시장의 경계를 허물 동료를 찾습니다"),
                 p(style = "font-size:0.95rem; color:#94A3B8; max-width:650px; line-height:1.6;", "MFL(Market Frontier Lab)은 비즈니스 데이터의 진정한 가치를 분석하고 발굴하여 실무 전략을 도출해내는 인재들의 연합입니다.")
             ),
             fluidRow(
               column(6,
                      div(style = "background:#FFFFFF; border:1px solid #E2E8F0; border-radius:20px; padding:34px 30px; height:100%; box-shadow:0 4px 6px rgba(0,0,0,0.01);",
                          h3(style="font-weight:800; color:#0F172A; margin-bottom:18px;", "🎯 지원 자격"),
                          tags$ul(style="padding-left:18px; color:#475569; line-height:2;",
                                  tags$li("전북대학교 재학생 및 휴학생 (학년 및 전공 무관)"),
                                  tags$li("통계학, 경제학, 비즈니스 분석 및 데이터 역량에 열정이 있는 분"),
                                  tags$li("매주 진행되는 정기 세션 및 팀 프로젝트에 성실히 참여 가능한 분")
                          )
                      )
               ),
               column(6,
                      div(style = "background: linear-gradient(145deg, #FFFFFF, #F1F5F9); border:1px solid #E2E8F0; border-radius:20px; padding:34px 30px; height:100%; box-shadow:0 4px 6px rgba(0,0,0,0.01);",
                          h3(style="font-weight:800; color:#2563EB; margin-bottom:18px;", "⭐ 우대 사항"),
                          tags$ul(style="padding-left:18px; color:#475569; line-height:2;",
                                  tags$li("ADsP(데이터분석준전문가) 혹은 사회조사분석사 2급 소지자"),
                                  tags$li("R, Python 등을 활용한 통계 패키지 및 시각화 유경험자"),
                                  tags$li("공모전, 리서치 프로젝트 등 주도적인 대외활동 경험자")
                          )
                      )
               )
             )
           )
  )
)

# ==========================================
# 2. SERVER (Logic)
# ==========================================
server <- function(input, output, session) {
  
  # [A] 세 줄 메뉴 선택 반영 이벤트 핸들링
  observeEvent(input$menu_select, {
    updateNavbarPage(session, "main_navbar", selected = input$menu_select)
  })
  
  # [B] 스마트 캘린더 동적 반응형 엔진
  calendar_data <- reactiveValues(
    schedules = list(
      "10" = c("정기 거시경제 데이터 리서치 워크숍"),
      "22" = c("소비재 및 의료·바이오 세부 시장 분석 기획")
    )
  )
  
  observeEvent(input$add_cal_btn, {
    req(input$cal_text)
    day <- input$cal_day
    text <- trimws(input$cal_text)
    
    if(text != "") {
      if(day %in% names(calendar_data$schedules)) {
        calendar_data$schedules[[day]] <- c(calendar_data$schedules[[day]], text)
      } else {
        calendar_data$schedules[[day]] <- text
      }
      updateTextInput(session, "cal_text", value = "")
      showNotification(paste0(day, "일에 새로운 활동 일정이 등록되었습니다."), type = "message")
    }
  })
  
  output$rendered_calendar <- renderUI({
    days_heading <- lapply(c("일","월","화","수","목","금","토"), function(d) {
      div(class = "calendar-header-day", d)
    })
    
    day_boxes <- lapply(1:28, function(i) {
      day_str <- as.character(i)
      items_ui <- NULL
      if(day_str %in% names(calendar_data$schedules)) {
        items_ui <- lapply(calendar_data$schedules[[day_str]], function(sch) {
          div(class = "calendar-schedule-item", sch)
        })
      }
      div(class = "calendar-day-box",
          div(class = "calendar-day-num", day_str),
          items_ui
      )
    })
    
    div(class = "calendar-grid",
        tagList(days_heading),
        tagList(day_boxes)
    )
  })
  
  # [C] 상/하반기 자동 분류 데이터베이스 피드 엔진
  posts_store <- reactiveValues(
    data = data.frame(
      title = c("상반기 포트폴리오 고도화 세션", "하반기 데이터 아카이빙 구축 세션"),
      author = c("MFL 대표운영진", "MFL 데이터분석팀"),
      tag = c("활동기록", "오픽/실무 스터디"),
      content = c("R Shiny 및 bslib 고급 테마 아키텍처를 연동하여 웹 애플리케이션 인터페이스의 가독성을 최적화하는 연구 세션 진행.", "하반기 축적 데이터의 데이터 무결성 확보를 위한 무결성 검증 및 시각화 자동화 대시보드 기획 전략 수립."),
      half = c("first", "second"), 
      stringsAsFactors = FALSE
    )
  )
  
  # 아카이브 새 게시물 등록 (상/하반기 입력 선택 필드 자동 필터링 반영)
  observeEvent(input$submit_post, {
    req(input$post_title, input$post_content)
    
    new_row <- data.frame(
      title = input$post_title,
      author = if(trimws(input$post_author) == "") "익명회원" else input$post_author,
      tag = input$post_tag,
      content = input$post_content,
      half = input$post_half, # 입력 폼에서 선택한 반기 데이터가 피드로 분기
      stringsAsFactors = FALSE
    )
    
    posts_store$data <- rbind(new_row, posts_store$data)
    showNotification("새 아카이브 리포트가 안전하게 저장되었습니다.", type = "message")
    
    updateTextInput(session, "post_title", value = "")
    updateTextInput(session, "post_author", value = "")
    updateTextAreaInput(session, "post_content", value = "")
  })
  
  # 피드 HTML 렌더러 빌더
  build_feed <- function(df_subset) {
    if(nrow(df_subset) == 0) {
      return(div(style="color:#64748B; text-align:center; padding: 40px; font-size:0.9rem;", "선택하신 반기에 등록된 데이터 아카이브가 없습니다."))
    }
    
    lapply(1:nrow(df_subset), function(i) {
      div(class = "post-card",
          div(class = "post-card-header",
              div(class = "post-card-title", df_subset$title[i]),
              div(class = "post-tag-badge", df_subset$tag[i])
          ),
          div(style="font-size:0.8rem; color:#64748B; margin-bottom:12px; font-weight:500;", paste("✍ 기록자:", df_subset$author[i])),
          div(style="white-space: pre-wrap; font-size:0.9rem; color:#334155; line-height:1.6;", df_subset$content[i])
      )
    })
  }
  
  # 상반기 탭 출력 피드
  output$news_feed_first <- renderUI({
    df <- posts_store$data
    build_feed(df[df$half == "first", ])
  })
  
  # 하반기 탭 출력 피드
  output$news_feed_second <- renderUI({
    df <- posts_store$data
    build_feed(df[df$half == "second", ])
  })
}

# ==========================================
# 3. RUN APPLICATION
# ==========================================
shinyApp(ui = ui, server = server)