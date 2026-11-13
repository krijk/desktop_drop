#include <flutter_linux/flutter_linux.h>
#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "include/desktop_drop/desktop_drop_plugin.h"
#include "desktop_drop_plugin_private.h"

// This demonstrates a simple unit test of the C portion of this plugin's
// implementation.
//
// Once you have built the plugin's example app, you can run these tests
// from the command line. For instance, for an x64 debug build, run
// $ build/linux/x64/debug/plugins/desktop_drop/desktop_drop_test

namespace desktop_drop {
namespace test {

TEST(DesktopDropPlugin, GetPlatformVersion) {
  g_autofree gchar* result = desktop_drop_plugin_get_platform_version();
  ASSERT_NE(result, nullptr);
  // The full string varies, so just validate that it has the right format.
  EXPECT_THAT(result, testing::StartsWith("Linux "));
}

}  // namespace test
}  // namespace desktop_drop
