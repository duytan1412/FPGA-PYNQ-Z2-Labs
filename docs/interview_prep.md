# Interview Preparation - FPGA Design & Verification

## 1. LED Blink Project

### Q: Giải thích cách Clock Divider hoạt động?
**A:** Clock divider dùng counter để đếm số xung clock. Với clock 100MHz, mỗi chu kỳ là 10ns. Để tạo 1Hz (1s), ta cần đếm 50 triệu xung (50_000_000). Khi counter đạt giá trị này, ta đảo output và reset counter.

### Q: Tại sao dùng parameter DIVISOR?
**A:** Parameter giúp module có thể tái sử dụng. Khi simulation, ta dùng DIVISOR nhỏ (5-10) để chạy nhanh. Khi synthesis, dùng 50_000_000 cho clock thực.

### Q: LED pattern hoạt động thế nào?
**A:** Dùng shift register 4-bit. Mỗi xung clock 1Hz, pattern dịch trái 1 bit. Bit cuối quay về đầu: `{led[2:0], led[3]}`. Tạo hiệu ứng LED chạy.

---

## 2. 7-Segment Counter Project

### Q: FSM trong project này ở đâu?
**A:** FSM nằm trong `seg7_control.v` để multiplexing 4 digit. Có 4 state: DIGIT_0, DIGIT_1, DIGIT_2, DIGIT_3. Mỗi state bật 1 digit và hiển thị số tương ứng.

### Q: Tại sao cần multiplexing?
**A:** 7-segment display có 4 digit nhưng dùng chung 7 đường segment. Để hiển thị 4 số khác nhau, ta bật từng digit rất nhanh (>60Hz). Mắt người thấy như 4 số sáng đồng thời.

### Q: Giải thích BCD counter?
**A:** BCD (Binary Coded Decimal) đếm từ 0-9 rồi reset. Khi ones = 9 và có carry, ones = 0, tens + 1. Tương tự cho hundreds và thousands.

### Q: Common Cathode vs Common Anode?
**A:** 
- Common Cathode: LED sáng khi segment = 1
- Common Anode: LED sáng khi segment = 0
PYNQ-Z2 dùng Common Cathode.

---

## 3. Button Up/Down Counter Project

### Q: Tại sao cần debounce?
**A:** Khi nhấn nút vật lý, tiếp điểm dao động tạo nhiều xung nhiễu (bouncing). Debounce lọc nhiễu này, chỉ nhận 1 xung duy nhất cho mỗi lần nhấn.

### Q: Debounce hoạt động thế nào?
**A:** Dùng counter đếm thời gian nút ổn định (khoảng 10-20ms). Chỉ khi nút giữ nguyên trạng thái đủ lâu, mới coi là nhấn hợp lệ.

### Q: Edge detection là gì?
**A:** Phát hiện cạnh lên (0→1) hoặc cạnh xuống (1→0) của tín hiệu. Dùng 2 flip-flop lưu trạng thái hiện tại và trước đó:
```verilog
posedge = current & ~previous;  // Cạnh lên
negedge = ~current & previous;  // Cạnh xuống
```

---

## 4. Câu hỏi chung về FPGA

### Q: FPGA là gì?
**A:** Field Programmable Gate Array - mảng cổng logic có thể lập trình. Gồm các CLB (Configurable Logic Block), LUT (Look-Up Table), Flip-Flop, và Block RAM.

### Q: LUT là gì?
**A:** Look-Up Table - bảng tra cứu thực hiện bất kỳ hàm logic nào. LUT 4-input có 16 ô nhớ, mỗi tổ hợp input cho 1 output định trước.

### Q: Verilog blocking vs non-blocking?
**A:**
- `=` (blocking): thực hiện tuần tự, dùng trong combinational logic
- `<=` (non-blocking): thực hiện song song, dùng trong sequential logic (always @(posedge clk))

### Q: Timing constraint là gì?
**A:** Ràng buộc thời gian đảm bảo tín hiệu đến đích trước edge clock tiếp theo. Setup time: data phải ổn định trước clock. Hold time: data phải giữ sau clock.

### Q: Synthesis là gì?
**A:** Quá trình chuyển code Verilog thành netlist (mạng các cổng logic). Vivado ánh xạ code vào LUT, FF, và tài nguyên FPGA.

---

## 5. Tips phỏng vấn

1. **Nói chậm, rõ ràng** - Không cần trả lời ngay, suy nghĩ rồi trả lời
2. **Vẽ sơ đồ** - Nếu được, vẽ block diagram hoặc timing diagram
3. **Thừa nhận không biết** - "Em chưa học đến phần này, nhưng em sẽ tìm hiểu thêm"
4. **Liên hệ project** - "Trong project 7-segment của em, em đã áp dụng..."
5. **Hỏi lại nếu không hiểu** - Thể hiện sự cẩn thận, không đoán bừa
