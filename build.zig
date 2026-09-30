const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Header-only "library": the artifact exists purely so that Zig can track
    // the header installation and add it to dependent include paths.
    const lib = b.addLibrary(.{
        .name = "vulkan-headers",
        .linkage = .static,
        .root_module = b.createModule(.{
            .root_source_file = b.addWriteFiles().add("empty.c", ""),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });

    inline for (.{ "vk_video", "vulkan" }) |subdir| {
        lib.installHeadersDirectory(b.path("include/" ++ subdir), subdir, .{});
    }
    b.installArtifact(lib);
}
