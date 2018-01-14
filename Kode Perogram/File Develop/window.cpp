#include <winsock2.h>
#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>
#include <wingdi.h>
#include <iostream>
#include <ruby.h>

static TCHAR szWindowClass[] = _T("win32api");
static TCHAR szTitle[] = _T("Win32 App");
static HINSTANCE hInst;

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

int CALLBACK BuatWindow(HINSTANCE hInstance, int nCmdShow)
{
	MSG msg;

	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);
	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = WndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = LoadIcon(hInstance, IDI_APPLICATION);
	wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName = NULL;
	wcex.lpszClassName = szWindowClass;
	wcex.hIconSm = LoadIcon(wcex.hInstance, IDI_APPLICATION);

	RegisterClassEx(&wcex);

	HWND hwnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, NULL, NULL, hInstance, NULL);

	ShowWindow(hwnd, nCmdShow);
	UpdateWindow(hwnd);
	
	while(GetMessage(&msg, NULL, 0, 0))
	{
		if(!TranslateAccelerator(msg.hwnd, 0, &msg))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}
	return 0;
}

char* minta_string(VALUE data_ruby){
	return StringValueCStr(data_ruby);
}

LRESULT CALLBACK WndProc(HWND h, UINT m, WPARAM w, LPARAM l)
{
	PAINTSTRUCT ps;
	HDC hdc;
	VALUE data_yield = rb_yield(Qnil);
	char* pesan = minta_string(data_yield);
	int panjang = RSTRING_LEN(data_yield);
	// VALUE klass = rb_const_get(rb_cModule, rb_intern("Data_Window"));
	// rb_data_type_t data_window_ex;
	// rb_data_typed_object_wrap(klass, rb_cModule, data_window_ex);

	switch(m)
	{
		case WM_PAINT:
		hdc = BeginPaint(h, &ps);
		TextOut(hdc, 0, 0, pesan, panjang);
		TextOut(hdc, 0, 15, pesan, panjang);
		EndPaint(h, &ps);
		break;
		case WM_DESTROY:
		PostQuitMessage(0);
		break;
		default:
		return DefWindowProc(h, m, w, l);
	}
	return 0;
}
// using namespace Rice;

void jalankan(ANYARGS) {
	BuatWindow(hInst, 1);
}

VALUE print_ruby(VALUE self, VALUE data_dari_ruby) {
	std::cout << minta_string(data_dari_ruby) << "\n";
	return Qnil;
}

extern "C"
void Init_mytest()
{
	VALUE Cls;
	Cls = rb_define_class("Buat_Window", rb_cObject);
	rb_define_method(Cls, "jalankan", RUBY_METHOD_FUNC(jalankan), 0);
	rb_define_method(Cls, "data_window", RUBY_METHOD_FUNC(print_ruby), 1);
}