#!/usr/bin/env dart
/// Converts relative imports to absolute `package:babysitter_app/` imports
/// across all .dart files in lib/ and test/.
///
/// Usage: dart run scripts/fix_relative_imports.dart [--dry-run]

import 'dart:io';
import 'package:path/path.dart' as p;

void main(List<String> args) {
  final dryRun = args.contains('--dry-run');
  final appRoot = Directory.current.path;
  final libDir = p.join(appRoot, 'lib');

  if (!Directory(libDir).existsSync()) {
    stderr.writeln('Error: must be run from the app root (where lib/ exists).');
    exit(1);
  }

  final dirs = [
    Directory(p.join(appRoot, 'lib')),
    Directory(p.join(appRoot, 'test')),
  ];

  final relativeImportPattern = RegExp(
    r'''(import\s+['"])(\.\./[^'"]+)(['"];)''',
  );

  var totalFiles = 0;
  var totalRewrites = 0;

  for (final dir in dirs) {
    if (!dir.existsSync()) continue;

    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      // Skip generated files
      if (entity.path.endsWith('.g.dart') ||
          entity.path.endsWith('.freezed.dart')) continue;

      final originalContent = entity.readAsStringSync();
      final fileDir = p.dirname(entity.path);
      var content = originalContent;
      var fileRewrites = 0;

      content = content.replaceAllMapped(relativeImportPattern, (match) {
        final prefix = match.group(1)!;
        final relativePath = match.group(2)!;
        final suffix = match.group(3)!;

        // Resolve the relative path to an absolute filesystem path
        final resolved = p.normalize(p.join(fileDir, relativePath));

        // Check if the resolved path falls within lib/
        if (!p.isWithin(libDir, resolved)) {
          // Relative import pointing outside lib/ — leave it alone
          return match.group(0)!;
        }

        // Convert to package: import
        final relativeToLib = p.relative(resolved, from: libDir);
        final packagePath =
            'package:babysitter_app/${relativeToLib.replaceAll(r'\', '/')}';

        fileRewrites++;
        return '$prefix$packagePath$suffix';
      });

      if (fileRewrites > 0) {
        totalFiles++;
        totalRewrites += fileRewrites;
        final shortPath = p.relative(entity.path, from: appRoot);
        print('  $shortPath ($fileRewrites imports)');
        if (!dryRun) {
          entity.writeAsStringSync(content);
        }
      }
    }
  }

  print('');
  if (dryRun) {
    print('[DRY RUN] Would rewrite $totalRewrites imports in $totalFiles files.');
  } else {
    print('Rewrote $totalRewrites imports in $totalFiles files.');
  }
}
