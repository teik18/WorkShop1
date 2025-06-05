<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div style="margin-top: 40px; padding: 20px; background-color: #f1f1f1; text-align: center; font-size: 14px; color: #555;">
    <p>&copy; <span id="year"></span> Group 4 - Stock Management</p>
    <p>
        Nguyễn Văn A - 2112345 |
        Trần Thị B - 2112346 |
        Lê Văn C - 2112347 |
        Phạm Thị D - 2112348
    </p>
</div>

<script>
    document.getElementById("year").textContent = new Date().getFullYear();
</script>
