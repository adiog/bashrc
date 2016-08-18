// This file is a part of cpp-training project.
// Copyright (c) 2016 Aleksander Gajewski <adiog@brainfuck.pl>.

#ifndef __TIMER__
#define __TIMER__

#include <sstream>
#include <chrono>
#include <stack>
#include <thread>

#ifndef HDP_LOG_DEBUG
#include <iostream>
#define HDP_LOG_DEBUG(msg) std::cout << msg << std::endl;
#endif

class timer
{
public:
    timer() = default;

    static timer &get()
    {
        static timer t;
        return t;
    }

    void _start()
    {
        time_points.push(std::chrono::steady_clock::now());
    }

    int _stop()
    {
        std::chrono::steady_clock::time_point last = time_points.top();
        time_points.pop();
        std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();
        return std::chrono::duration_cast<std::chrono::microseconds>(end - last).count();
    }

    int push_uid()
    {
        uids.push(++max_uid);
        return max_uid;
    }

    int pop_uid()
    {
        int uid = uids.top();
        uids.pop();
        return uid;
    }

    static void start(const char *FILE, int LINE, const char *PRETTY_FUNCTION)
    {
        std::ostringstream oss_file;
        std::ostringstream oss_func;
        int uid = timer::get().push_uid();
        oss_file << " ### <<< " << uid << " " << FILE << ":" << LINE;
        oss_func << " ### <<< " << uid << " " << PRETTY_FUNCTION;
        HDP_LOG_DEBUG(oss_file.str());
        HDP_LOG_DEBUG(oss_func.str());
        timer::get()._start();
    }
    static void stop(const char *FILE, int LINE, const char *PRETTY_FUNCTION)
    {
        std::ostringstream oss_file;
        std::ostringstream oss_func;
        int uid = timer::get().pop_uid();
        float ms_time = static_cast<float>(timer::get()._stop()) / 1000;
        oss_file << " ### >>> " << uid << " " << FILE << ":" << LINE;
        oss_func << " ### >>> " << uid << " " << PRETTY_FUNCTION << ": [" << ms_time << "ms]";
        HDP_LOG_DEBUG(oss_file.str());
        HDP_LOG_DEBUG(oss_func.str());
    }

private:
    std::stack<std::chrono::steady_clock::time_point> time_points;
    std::stack<int> uids;
    int max_uid;
};

class measure
{
public:
    measure(const char *FILE, int LINE, const char *PRETTY_FUNCTION)
            : file(FILE), line(LINE), pretty_function(PRETTY_FUNCTION)
    {
        timer::start(file, line, pretty_function);
    }

    ~measure()
    {
        timer::stop(file, line, pretty_function);
    }

private:
    const char *file;
    int line;
    const char *pretty_function;
};

#define TIC timer::get().start(__FILE__, __LINE__, __PRETTY_FUNCTION__)
#define TAC timer::get().stop(__FILE__, __LINE__, __PRETTY_FUNCTION__)
#define MEASURE_SCOPE measure measure_time_##__LINE__(__FILE__, __LINE__, __PRETTY_FUNCTION__)
#define MEASURE_FUNC(foo) \
    do {\
        timer::get().start(__FILE__, __LINE__, __PRETTY_FUNCTION__); \
        (foo); \
        timer::get().stop(__FILE__, __LINE__, __PRETTY_FUNCTION__); \
    } while (0);

#endif  // __TIMER__
