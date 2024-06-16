#!/bin/bash

# # /mytmp 디렉토리 생성
# mkdir -p /mytmp
# cd /mytmp

# # healthcheck_server.py 파일 작성
# cat << 'EOF' > healthcheck_server.py
# from http.server import BaseHTTPRequestHandler, HTTPServer

# class RequestHandler(BaseHTTPRequestHandler):
#     def do_GET(self):
#         if self.path == "/healthcheck":
#             self.send_response(200)
#             self.send_header("Content-type", "text/plain")
#             self.end_headers()
#             self.wfile.write(b"OK")
#         else:
#             self.send_response(404)
#             self.end_headers()

# def run(server_class=HTTPServer, handler_class=RequestHandler, port=8080):
#     server_address = ("", port)
#     httpd = server_class(server_address, handler_class)
#     print(f"Serving on port {port}...")
#     httpd.serve_forever()

# if __name__ == "__main__":
#     run()
# EOF

# # 백그라운드에서 서버 실행하고 PID 저장
# nohup python3 healthcheck_server.py &
# echo $! > /mytmp/healthcheck_server.pid