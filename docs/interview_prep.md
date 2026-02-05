# 🎯 BỘ CÂU HỎI PHỎNG VẤN FPT SEMICONDUCTOR
## FPGA Design & Verification Intern

---

# PHẦN A: CÂU HỎI CÁ NHÂN (100% sẽ hỏi)

---

## ❓ "Tại sao em chuyển từ Y khoa sang Chip Design?"

### ✅ Câu trả lời mẫu:
> "Trong Y khoa, em được đào tạo tư duy **chẩn đoán hệ thống** - phải phân tích triệu chứng, loại trừ khả năng, tìm ra nguyên nhân gốc rễ. Khi tiếp xúc với Chip Design, em nhận ra tư duy này hoàn toàn áp dụng được vào **debugging mạch số**.
>
> Hơn nữa, học Y rất áp lực - sai là chết người. Nên giờ khi viết code Verilog, em luôn bị ám ảnh việc code phải **chạy đúng tuyệt đối**. Đó là lý do em đầu tư mạnh vào **Self-Checking Testbench** - để verify 100% logic trước khi synthesis."

### 💡 Tại sao trả lời như vậy?
- Biến điểm yếu (không đúng ngành) thành điểm mạnh (tư duy diagnostic)
- Thể hiện "Verification First" mindset - đúng văn hóa Semiconductor
- Kết nối với project thực tế trong CV

---

## ❓ "Em có kinh nghiệm làm việc nhóm chưa?"

### ✅ Câu trả lời mẫu:
> "Tại FPT Jetking, em làm các bài lab theo nhóm 2-3 người. Cụ thể với project 7-Segment Counter, em phụ trách phần **RTL coding** còn bạn em lo phần **testbench và waveform verification**. Khi có conflict về cách implement Clock Divider, bọn em ngồi lại review code cùng nhau và chọn solution tối ưu nhất về timing."

### 💡 Tips:
- Dù làm 1 mình cũng nên frame là "có discuss với bạn/thầy"
- Nhấn mạnh skill: communication, conflict resolution

---

# PHẦN B: CÂU HỎI LÝ THUYẾT (90% sẽ hỏi)

---

## ❓ "Blocking (=) và Non-blocking (<=) khác nhau thế nào?"

### ✅ Câu trả lời:
> "**Blocking (=)**: Thực hiện **tuần tự**, câu lệnh sau phải chờ câu lệnh trước hoàn thành. Dùng cho **combinational logic** trong `always @(*)`.
>
> **Non-blocking (<=)**: Thực hiện **song song**, tất cả assignments cập nhật cùng lúc ở cuối time step. Dùng cho **sequential logic** trong `always @(posedge clk)`.
>
> Nếu dùng **blocking trong sequential logic** sẽ gây ra **race condition** - kết quả phụ thuộc thứ tự thực thi."

### 📝 Ví dụ code:
```verilog
// SAI - dùng blocking trong sequential
always @(posedge clk) begin
    a = b;      // a cập nhật ngay
    c = a;      // c nhận giá trị MỚI của a
end

// ĐÚNG - dùng non-blocking
always @(posedge clk) begin
    a <= b;     // Schedule: a = b_old
    c <= a;     // Schedule: c = a_old (giá trị CŨ)
end
```

---

## ❓ "Moore Machine khác Mealy Machine thế nào?"

### ✅ Câu trả lời:
> | | Moore | Mealy |
> |---|---|---|
> | **Output** | f(state) | f(state, input) |
> | **Timing** | Ổn định, ít glitch | Có thể glitch khi input thay đổi |
> | **Speed** | Chậm hơn 1 cycle | Nhanh hơn 1 cycle |
> | **States** | Cần nhiều state hơn | Ít state hơn |
>
> "Em chọn **Moore** cho Vending Machine vì output `dispense` cần **ổn định** - không được phép glitch khi đang xuất hàng. Moore an toàn hơn về timing."

---

## ❓ "Setup time và Hold time là gì?"

### ✅ Câu trả lời:
> "**Setup time (Tsu)**: Thời gian data phải **ổn định TRƯỚC** cạnh clock. Nếu vi phạm → Flip-flop bắt sai giá trị.
>
> **Hold time (Th)**: Thời gian data phải **giữ nguyên SAU** cạnh clock. Nếu vi phạm → Data bị corrupt.
>
> Trong Vivado, em check **Timing Report** sau synthesis. Nếu có **negative slack** nghĩa là timing violation."

### 📝 Hình minh họa:
```
        ←─ Setup ─→←─ Hold ─→
                   │
Data:  ───────────┼───────────
                   │
Clock: ─────────┐ │ ┌─────────
                └─┴─┘
                  ↑
             Rising Edge
```

---

## ❓ "Flip-flop khác Latch thế nào?"

### ✅ Câu trả lời:
> | | Flip-flop | Latch |
> |---|---|---|
> | **Trigger** | Edge-triggered (cạnh lên/xuống) | Level-triggered (mức cao/thấp) |
> | **Timing** | Dễ kiểm soát, predictable | Khó kiểm soát, có thể transparent |
> | **FPGA** | Được ưu tiên sử dụng | **Tránh dùng** - gây timing issues |
>
> "Trong FPGA design, em luôn dùng **Flip-flop** (always @posedge clk). Latch chỉ xuất hiện khi code không đúng - ví dụ thiếu default trong case statement."

---

# PHẦN C: CÂU HỎI VỀ PROJECT

---

## 🎯 PROJECT 1: SMART VENDING MACHINE

### ❓ [DỄ] "Vẽ State Diagram và giải thích từng state"

### ✅ Câu trả lời:
> *[Vẽ lên bảng]*
> ```
>     ┌──────────────────────────────────────┐
>     │                                      │
>     ▼                                      │
> ┌────────┐  coin   ┌────────────┐          │
> │  IDLE  │────────▶│ ACCUMULATE │          │
> └───┬────┘         └─────┬──────┘          │
>     │                    │ item_sel        │
>     │ cancel             ▼                 │
>     │              ┌──────────┐            │
>     │              │  SELECT  │            │
>     │              └────┬─────┘            │
>     │         ┌─────────┴─────────┐        │
>     │   balance >= price    balance < price│
>     │         ▼                   ▼        │
>     │   ┌──────────┐       ┌─────────┐     │
>     │   │ DISPENSE │       │  ERROR  │     │
>     │   └────┬─────┘       └────┬────┘     │
>     │        │                  │          │
>     │        ▼                  │          │
>     │   ┌──────────┐            │          │
>     └──▶│  CHANGE  │◀───────────┘          │
>         └────┬─────┘                       │
>              └─────────────────────────────┘
> ```
>
> - **IDLE**: Chờ tiền, clear outputs
> - **ACCUMULATE**: Cộng tiền vào balance
> - **SELECT**: Kiểm tra đủ tiền không
> - **DISPENSE**: Xuất hàng, trừ tiền
> - **CHANGE**: Trả tiền thừa
> - **ERROR**: Báo lỗi thiếu tiền

---

### ❓ [TRUNG BÌNH] "Self-Checking Testbench hoạt động thế nào?"

### ✅ Câu trả lời:
> "Thay vì nhìn waveform bằng mắt, em viết testbench **tự động so sánh** output với expected value:
>
> ```verilog
> if (balance == expected_balance && 
>     dispense == expected_dispense)
>     $display("[PASS] Test %0d", test_num);
> else
>     $display("[FAIL] Test %0d", test_num);
> ```
>
> Em test **8 corner cases**:
> 1. Insufficient funds
> 2. Exact change
> 3. Change calculation
> 4. Cancel with zero balance
> 5. Cancel with balance (refund)
> 6. **Overflow protection** (balance > 99)
> 7. Select without coin
> 8. **Async reset** mid-transaction"

---

### ❓ [KHÓ] "Nếu user nhấn 'Chọn món' và 'Hủy' cùng lúc thì sao?"

### ✅ Câu trả lời:
> "Đây là **race condition**. Trong design của em, em xử lý bằng **Priority Encoding**:
>
> ```verilog
> if (cancel)           // Cancel có priority cao nhất
>     next_state = CHANGE;
> else if (item_sel != 0) 
>     next_state = SELECT;
> ```
>
> Cancel luôn được ưu tiên vì user muốn lấy lại tiền là **safety-critical** - giống như Brake Override trong ô tô.
>
> Nếu cần xử lý phức tạp hơn, em có thể thêm **Arbiter module** để quyết định input nào được xử lý trước."

---

## 📟 PROJECT 2: FPGA 7-SEGMENT COUNTER

### ❓ [DỄ] "Tại sao dùng 74HC595 Shift Register?"

### ✅ Câu trả lời:
> "Để **tối ưu I/O pins**. 
>
> - Nối trực tiếp: 4 digit × 8 segment = **32 pins**
> - Dùng 74HC595: Chỉ cần **3 pins** (DIO, SCLK, RCLK)
>
> 74HC595 nhận data **serial** qua SPI protocol và output **parallel** 8-bit. Em cascade 2 con 74HC595 để có 16-bit output (8 segment + 4 digit select)."

---

### ❓ [TRUNG BÌNH] "Tần số quét bao nhiêu để không nhấp nháy?"

### ✅ Câu trả lời:
> "Mắt người có **Persistence of Vision** khoảng 16ms (~60Hz). Để không nhấp nháy, mỗi digit phải được refresh ít nhất 60 lần/giây.
>
> Với 4 digits: 60Hz × 4 = **240Hz minimum**
>
> Clock 100MHz ÷ 240Hz = **~416,667**
>
> Nhưng thực tế em chia cho **100,000** để có **1kHz** refresh rate - đủ an toàn và để margin cho timing."

---

### ❓ [KHÓ] "Em gặp timing violation gì khi synthesis?"

### ✅ Câu trả lời:
> "Với project đơn giản này, em **không gặp timing violation** vì:
> - Logic không sâu (few levels of LUT)
> - Clock 100MHz có period 10ns - rất thoải mái cho Zynq-7000
>
> Nhưng em vẫn check **Timing Summary** sau synthesis. Nếu có negative slack, em sẽ:
> 1. **Pipeline** đường critical path
> 2. **Retiming** để balance logic
> 3. Hoặc giảm clock frequency
>
> Em hiểu rằng trong production, **timing closure** là phase quan trọng nhất."

---

## 🚗 PROJECT 3: AUTOSPEED-CONTROL

### ❓ [DỄ] "Unit Test là gì?"

### ✅ Câu trả lời:
> "**Unit Test** kiểm tra **từng module độc lập**. Ví dụ test riêng Throttle logic, test riêng Brake logic.
>
> **Integration Test** kiểm tra **nhiều modules kết hợp** - ví dụ Throttle + Brake + Gear hoạt động cùng nhau.
>
> Em dùng **Unit Test** trước để catch bug sớm. Sau khi pass hết mới chạy Integration Test."

---

### ❓ [TRUNG BÌNH] "Brake Override hoạt động thế nào?"

### ✅ Câu trả lời:
> "**Brake Override**: Khi đạp phanh, hệ thống **ignore throttle** và **cut power** ngay lập tức.
>
> ```cpp
> if (brake_pressed) {
>     throttle_output = 0;  // Force throttle to 0
>     engine_power = 0;     // Cut engine power
> }
> ```
>
> Đây là **safety-critical feature** sau vụ Toyota recall 2009-2011. Em test case này với input:
> - Throttle = 100%
> - Brake = pressed
> - Expected: Throttle output = **0%** (không phải 100%)"

---

### ❓ [KHÓ] "Hardware Verify khác Software Verify thế nào?"

### ✅ Câu trả lời:
> | | Software (C++) | Hardware (Verilog) |
> |---|---|---|
> | **Execution** | Tuần tự | **Song song** |
> | **Timing** | Không quan trọng | **Critical** (clock cycles) |
> | **State** | Variables | **Flip-flops** |
> | **Debug** | Breakpoint, step | **Waveform** |
> | **Coverage** | Line/Branch | **FSM states, toggles** |
>
> "Verify phần cứng phức tạp hơn vì mọi thứ chạy **concurrent**. Một bug có thể chỉ xuất hiện ở **clock cycle thứ 1 triệu** - nên cần **automated testbench** thay vì test manual."

---

# PHẦN D: CÂU HỎI "BẪY"

---

## ❓ "Em có biết UVM không?"

### ✅ Câu trả lời (thành thật):
> "Em biết **UVM (Universal Verification Methodology)** là chuẩn công nghiệp sử dụng **SystemVerilog OOP** để tạo reusable testbench. 
>
> Hiện tại em nắm chắc Verilog testbench cơ bản. Em đang tự học thêm về **SystemVerilog classes** và **constrained random** để tiếp cận UVM.
>
> Em hiểu FPT Semiconductor có training program - em rất mong được học UVM chính thức tại đây."

### 💡 Tại sao trả lời như vậy?
- Thành thật: không biết thì nói không biết
- Thể hiện đang tự học: proactive attitude
- Mở đường cho họ training: cho thấy willing to learn

---

## ❓ "Khó khăn lớn nhất trong project là gì?"

### ✅ Câu trả lời:
> "Với Vending Machine, bug khó nhất là **FSM bị kẹt ở state ERROR**. 
>
> Nguyên nhân: Em thiếu transition từ ERROR về IDLE.
>
> Cách debug: Em soi **waveform**, thấy `state_out` stuck ở giá trị 5 (ERROR). Check code thì phát hiện case ERROR không có `next_state = IDLE`.
>
> Bài học: Luôn **vẽ State Diagram đầy đủ** trước khi code, và **check mọi state đều có exit path**."

---

# PHẦN E: CHECKLIST TRƯỚC PHỎNG VẤN

- [ ] Thuộc lòng: Blocking vs Non-blocking
- [ ] Thuộc lòng: Moore vs Mealy
- [ ] Vẽ được: State Diagram Vending Machine (30 giây)
- [ ] Giải thích được: Tại sao bỏ Y khoa
- [ ] Mang theo: Laptop có Vivado + project
- [ ] Mở sẵn: Waveform của Vending Machine
- [ ] Mặc: Áo sơ mi, không cần vest

---

**🎯 GOOD LUCK!**
