//
// Created by Œ‚÷æ±Û on 2017/12/29.
//
#include "Common.h"
#include "Log.h"

namespace cplus11 {
    std::shared_ptr<spdlog::logger> logger;
}

using namespace cplus11;

int main(int argc, char* argv[]) {
    logger = spdlog::stdout_logger_mt("test");
    logger->set_pattern("[%l] %Y%m%d %H:%M:%S %t [%n] %v");
    logger->set_level((spdlog::level::level_enum)0);
    logger->flush_on((spdlog::level::level_enum)0);

    Common common;
    common.fun();

    return 0;
}
