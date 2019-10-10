
#pragma once
#include <types.h>
#include <string>
#include <sstream>

#ifdef WIN32
typedef std::wstring PLSTRING;
#else
typedef std::string PLSTRING;
#endif // _WIN32

class Utils
{
public:
	static void convetToWChar(wchar_t* buffer, const char* text);
    static PLSTRING stringToWs(const PLSTRING& s);
    static PLSTRING wsToString(const PLSTRING& ws);
    static wchar_t* wstring2wchar(PLSTRING source);
	template<typename T> static std::string anyToString(const T& t);
};

template<typename T> std::string Utils::anyToString(const T& t)
{
	std::stringstream ss;
	ss << t;
	return ss.str();
}
