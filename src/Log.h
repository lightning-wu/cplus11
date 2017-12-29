// Copyright (c) 2017, ofo Inc.
// All rights reserved.
// Created on 2017/12/7 上午10:33.
//

#ifndef AD_RESOURCE_SERVER_LOG_H
#define AD_RESOURCE_SERVER_LOG_H

#include <iostream>
#include <time.h>
#include <spdlog/spdlog.h>

namespace cplus11 {
extern std::shared_ptr<spdlog::logger> logger;
enum LogLevel {
    TRACE = 0,
    DEBUG,
    INFO,
    WARNING,
    ERROR
};


static void SpdLogHandler(LogLevel level, const char* filename, int line,
                          const char *fmt, va_list ap);

static void LogHandler(LogLevel level, const char* filename, int line,
                       const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    SpdLogHandler(level, filename, line, fmt, ap);
    va_end(ap);
}


static void SpdLogHandler(LogLevel level, const char* filename, int line,
                       const char *fmt, va_list ap){
    char buf[2048];
    char msg[1024];
    vsnprintf(msg, 1024, fmt, ap);
    snprintf(buf, sizeof(buf), "%s:%d %s", filename, line, msg);
    switch (level) {
        case TRACE:
            logger->trace(buf);
            break;
        case DEBUG:
            logger->debug(buf);
            break;
        case INFO:
            logger->info(buf);
            break;
        case WARNING:
            logger->warn(buf);
            break;
        case ERROR:
            logger->error(buf);
            break;
        default:
            break;
    }
}

#define LOG(level, fmt, arg...) LogHandler(level, __FILE__, __LINE__, fmt, ##arg)



}

#endif //AD_RESOURCE_SERVER_LOG_H
