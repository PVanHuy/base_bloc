const fs = require('fs');
const path = require('path');
const readline = require('readline');

// Run from this directory with: node auto_gen_file.js
const baseFolder = path.resolve(__dirname, '../');

const templates = {
  controller: (className) => `import 'package:flutter_bloc/flutter_bloc.dart';

import '${toSnakeCase(className)}_event.dart';
import '${toSnakeCase(className)}_state.dart';

class ${className}Controller
    extends Bloc<${className}Event, ${className}State> {
  ${className}Controller() : super(const ${className}Initial()) {
    // Register events here.
  }
}
`,
  event: (className) => `sealed class ${className}Event {
  const ${className}Event();
}
`,
  state: (className) => `sealed class ${className}State {
  const ${className}State();
}

final class ${className}Initial extends ${className}State {
  const ${className}Initial();
}
`,
  parameter: (className) => `class ${className}Parameter {
  const ${className}Parameter();
}
`,
  page: (className) => `import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '${toSnakeCase(className)}_controller.dart';
import '${toSnakeCase(className)}_event.dart';
import '${toSnakeCase(className)}_state.dart';

class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ${className}Controller(),
      child: const ${className}View(),
    );
  }
}

class ${className}View extends StatelessWidget {
  const ${className}View({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<${className}Controller, ${className}State>(
      builder: (context, state) {
        return const Scaffold(
          body: SizedBox.shrink(),
        );
      },
    );
  }
}
`,
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

rl.question('Enter your new page folder name: ', (name) => {
  try {
    const folderName = normalizeFolderName(name);
    const className = getClassNameFromFile(folderName);
    const outputDir = path.join(baseFolder, folderName);

    fs.mkdirSync(outputDir, { recursive: true });

    writeFile(
      outputDir,
      `${folderName}_controller.dart`,
      templates.controller(className),
    );

    writeFile(
      outputDir,
      `${folderName}_event.dart`,
      templates.event(className),
    );

    writeFile(
      outputDir,
      `${folderName}_state.dart`,
      templates.state(className),
    );

    writeFile(
      outputDir,
      `${folderName}_parameter.dart`,
      templates.parameter(className),
    );

    writeFile(
      outputDir,
      `${folderName}_page.dart`,
      templates.page(className),
    );

    console.log('');
    console.log(`Created ${className} page successfully:`);
    console.log(outputDir);
    console.log('');
    console.log('Files:');
    console.log(`- ${folderName}_page.dart`);
    console.log(`- ${folderName}_controller.dart`);
    console.log(`- ${folderName}_event.dart`);
    console.log(`- ${folderName}_state.dart`);
    console.log(`- ${folderName}_parameter.dart`);
  } catch (error) {
    console.error(`Could not create page: ${error.message}`);
    process.exitCode = 1;
  } finally {
    rl.close();
  }
});

function writeFile(outputDir, fileName, content) {
  const filePath = path.join(outputDir, fileName);
  if (fs.existsSync(filePath)) {
    throw new Error(`File already exists: ${filePath}`);
  }
  fs.writeFileSync(filePath, content);
}

function normalizeFolderName(value) {
  const name = value
    .trim()
    .toLowerCase()
    .replace(/\s+/g, '_');

  if (!/^[a-z][a-z0-9_]*$/.test(name)) {
    throw new Error(
      'Use a snake_case folder name, for example device_status',
    );
  }

  return name;
}

function getClassNameFromFile(name) {
  return name
    .split('_')
    .filter(Boolean)
    .map((part) => part[0].toUpperCase() + part.slice(1))
    .join('');
}

function toSnakeCase(value) {
  return value
    .replace(/([a-z0-9])([A-Z])/g, '$1_$2')
    .toLowerCase();
}
