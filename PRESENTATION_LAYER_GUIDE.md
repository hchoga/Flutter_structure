# Presentation Layer Guide - Typography

## Accessing Text Styles in UI Widgets

Access all text styles (both standard Flutter and custom) through the unified `context.textTheme` interface. Custom text styles are registered in your theme and available alongside Flutter's standard TextTheme properties.

### **Quick Reference**

```dart
// Standard Flutter TextTheme styles
Text('Heading', style: context.textTheme.headlineLarge);   // 48px, Bold
Text('Body', style: context.textTheme.bodyMedium);          // 16px, Regular

// Custom heading shortcuts (h1-h6)
Text('Large Title', style: context.textTheme.h1);           // 48px, Bold
Text('Medium Title', style: context.textTheme.h4);          // 24px, Bold
Text('Small Title', style: context.textTheme.h6);           // 18px, Bold

// Custom body styles with weight variants
Text('Bold Text', style: context.textTheme.bodyMediumBold);       // 16px, w700
Text('Medium Text', style: context.textTheme.bodyMediumMedium);   // 16px, w500
Text('Regular Text', style: context.textTheme.bodyMediumRegular); // 16px, w400
```

### **Available Text Style Properties**

```dart
// Standard Flutter TextTheme (all accessible)
context.textTheme.headlineLarge, headlineMedium, headlineSmall
context.textTheme.titleLarge, titleMedium, titleSmall
context.textTheme.bodyLarge, bodyMedium, bodySmall
context.textTheme.labelLarge, labelMedium, labelSmall
context.textTheme.displayLarge, displayMedium, displaySmall

// Custom Heading Shortcuts (h1-h6 - all Bold)
context.textTheme.h1    // 48px, Bold (w700)
context.textTheme.h2    // 40px, Bold (w700)
context.textTheme.h3    // 32px, Bold (w700)
context.textTheme.h4    // 24px, Bold (w700)
context.textTheme.h5    // 20px, Bold (w700)
context.textTheme.h6    // 18px, Bold (w700)

// Custom Body Large (18px)
context.textTheme.bodyLargeBold       // w700
context.textTheme.bodyLargeMedium     // w500
context.textTheme.bodyLargeRegular    // w400

// Custom Body Medium (16px)
context.textTheme.bodyMediumBold      // w700
context.textTheme.bodyMediumMedium    // w500
context.textTheme.bodyMediumRegular   // w400

// Custom Body Small (14px)
context.textTheme.bodySmallBold       // w700
context.textTheme.bodySmallMedium     // w500
context.textTheme.bodySmallRegular    // w400

// Custom Body Very Small (12px)
context.textTheme.bodyVerySmallRegular // w400
```

---

## **Verify Your Setup**

Navigate to `/test-typography` to see all available text styles in action:

```dart
// In your app, navigate to the test page
context.pushNamed(RoutesName.testTypography.name);
```

The test page demonstrates:
- All heading and title styles
- All body and label styles
- Practical UI examples (forms, lists, cards)
- Light/dark theme support

---

## **Complete Text Style Hierarchy**

### **Headline Styles (Bold)**
Use these for page titles, section headers, and prominent text.

| Property | Size | Weight | Usage |
|----------|------|--------|-------|
| `headlineLarge` | 48px | Bold (w700) | Page title, main heading |
| `headlineMedium` | 40px | Bold (w700) | Section title |
| `headlineSmall` | 32px | Bold (w700) | Subsection title |

**Example:**
```dart
Text(
  'Welcome to App',
  style: context.textTheme.headlineLarge,
);
```

---

### **Title Styles (Bold)**
Use for card titles, list headings, and secondary headlines.

| Property | Size | Weight | Usage |
|----------|------|--------|-------|
| `titleLarge` | 24px | Bold (w700) | Card title, major heading |
| `titleMedium` | 20px | Bold (w700) | List item heading |
| `titleSmall` | 18px | Bold (w700) | Minor heading |

**Example:**
```dart
Text(
  'Account Settings',
  style: context.textTheme.titleLarge,
);
```

---

### **Body Styles (Regular)**
Use for main body content, descriptions, and standard text.

| Property | Size | Weight | Usage |
|----------|------|--------|-------|
| `bodyLarge` | 18px | Regular (w400) | Main body text |
| `bodyMedium` | 16px | Regular (w400) | Standard text, labels |
| `bodySmall` | 14px | Regular (w400) | Secondary text, captions |

**Example:**
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Description:', style: context.textTheme.bodyMedium),
    SizedBox(height: 8),
    Text(
      'This is detailed information',
      style: context.textTheme.bodySmall,
    ),
  ],
);
```

---

### **Label Styles (Regular)**
Use for labels, tags, and small UI text.

| Property | Size | Weight | Usage |
|----------|------|--------|-------|
| `labelLarge` | 18px | Regular (w400) | Large label |
| `labelMedium` | 16px | Regular (w400) | Standard label |
| `labelSmall` | 14px | Regular (w400) | Small label |

**Example:**
```dart
Chip(
  label: Text(
    'Active',
    style: context.textTheme.labelMedium,
  ),
);
```

---

### **Custom Heading Styles (h1-h6)**
Quick shortcuts for heading styles. All are Bold (w700) and ready to use.

| Property | Size | Usage |
|----------|------|-------|
| `h1` | 48px | Page title, main heading |
| `h2` | 40px | Section title |
| `h3` | 32px | Subsection title |
| `h4` | 24px | Card title |
| `h5` | 20px | List item heading |
| `h6` | 18px | Minor heading |

**Example:**
```dart
Text('Welcome', style: context.textTheme.h1);
Text('Account', style: context.textTheme.h4);
Text('Settings', style: context.textTheme.h5);
```

---

### **Custom Body Styles with Weight Variants**
Flexible body styles with Bold, Medium, and Regular weight options.

**Body Large (18px):**
```dart
Text('Bold text', style: context.textTheme.bodyLargeBold);        // w700
Text('Medium text', style: context.textTheme.bodyLargeMedium);    // w500
Text('Regular text', style: context.textTheme.bodyLargeRegular);  // w400
```

**Body Medium (16px):**
```dart
Text('Bold label', style: context.textTheme.bodyMediumBold);      // w700
Text('Medium text', style: context.textTheme.bodyMediumMedium);   // w500
Text('Helper text', style: context.textTheme.bodyMediumRegular);  // w400
```

**Body Small (14px):**
```dart
Text('Important note', style: context.textTheme.bodySmallBold);   // w700
Text('Secondary text', style: context.textTheme.bodySmallMedium); // w500
Text('Caption text', style: context.textTheme.bodySmallRegular);  // w400
```

**Body Very Small (12px):**
```dart
Text('Disclaimer', style: context.textTheme.bodyVerySmallRegular); // w400
```

---

## **Usage Patterns in Widgets**

### **1. Page Title**
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Home',
            style: context.textTheme.h1,  // Using custom shortcut
          ),
          SizedBox(height: 24),
          // ... rest of content
        ],
      ),
    );
  }
}
```

### **2. List Items**
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(
        items[index].title,
        style: context.textTheme.h5,  // Custom shortcut
      ),
      subtitle: Text(
        items[index].description,
        style: context.textTheme.bodySmall,
      ),
    );
  },
);
```

### **3. Form Labels & Fields**
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Email Address',
      style: context.textTheme.bodyMediumBold,  // Custom bold variant
    ),
    SizedBox(height: 8),
    TextField(
      decoration: InputDecoration(
        hintText: 'Enter your email',
        hintStyle: context.textTheme.bodySmallRegular,  // Custom regular variant
        border: OutlineInputBorder(),
      ),
    ),
    SizedBox(height: 4),
    Text(
      'We use this to send password reset links',
      style: context.textTheme.bodySmallRegular.copyWith(
        color: Colors.grey,
      ),
    ),
  ],
);
```

### **4. Dialog Content**
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(
      'Confirm Action',
      style: context.textTheme.h4,  // Custom shortcut
    ),
    content: Text(
      'Are you sure you want to proceed?',
      style: context.textTheme.bodyMediumRegular,  // Custom variant
    ),
    actions: [
      TextButton(
        child: Text(
          'Cancel',
          style: context.textTheme.bodyMedium,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  ),
);
```

### **5. Cards & Containers**
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Balance',
          style: context.textTheme.bodySmallRegular,  // Custom variant
        ),
        SizedBox(height: 8),
        Text(
          '\$1,234.56',
          style: context.textTheme.h2,  // Custom shortcut
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available: \$1,000',
              style: context.textTheme.bodyMediumMedium,  // Custom medium weight
            ),
            Text(
              'Pending: \$234.56',
              style: context.textTheme.bodyMediumBold,  // Custom bold variant
            ),
          ],
        ),
      ],
    ),
  ),
);
```

---

## **How It Works with Theme**

Your custom text styles are seamlessly integrated into your app's theme through a unified interface:

1. **Styles defined**: `TextStyleExtension.standard` in `lib/core/theme/app_text_styles.dart`
   - Contains all style definitions (h1-h6, bodyLarge variants, bodyMedium variants, etc.)
   - Each style has specific fontSize and fontWeight

2. **Theme mapping**: Both light and dark themes map these custom styles to Flutter's standard `TextTheme` (lines 36-50 and 103-117 in `app_theme.dart`)
   - Standard Flutter styles are mapped as usual
   - Custom styles are registered via `extensions`

3. **Unified access**: A custom `CustomTextTheme` wrapper (in `text_style_extension.dart`) combines both:
   - Standard Flutter TextTheme properties (headlineLarge, bodyMedium, etc.)
   - Custom style shortcuts (h1-h6, bodyMediumBold, bodySmallRegular, etc.)
   - All accessible through single interface: `context.textTheme`

4. **Easy access**: All styles available in one place:
   ```dart
   context.textTheme.headlineLarge    // Standard Flutter - 48px
   context.textTheme.h1               // Custom shortcut - 48px, Bold (same)
   context.textTheme.bodyMedium       // Standard Flutter - 16px
   context.textTheme.bodyMediumBold   // Custom variant - 16px, Bold
   ```

5. **Single source of truth**: All style definitions in `TextStyleExtension.standard`:
   - Change size or weight in one place
   - Updates everywhere automatically through the theme system

### **Theme Mapping Structure**
```
TextStyleExtension.standard (Definitions)
  ↓
app_theme.dart (Light/Dark Mapping to Flutter TextTheme)
  ↓
CustomTextTheme wrapper (Combines standard + custom styles)
  ↓
context.textTheme (Unified User Access)
```

**Example Flow:**
```
TextStyleExtension.standard.h1 (48px, Bold)
  ↓
app_theme.dart: headlineLarge → TextStyleExtension.standard.h1
  ↓
CustomTextTheme: h1 property returns custom style
  ↓
context.textTheme.h1 or context.textTheme.headlineLarge (both work!)
```

---

## **Best Practices**

✅ **DO:**
- Always use `context.textTheme.<property>` instead of hardcoding TextStyle
- Choose the right semantic level (headline > title > body > label)
- Use smaller sizes for secondary information
- Combine text styles with proper spacing
- Text styles adapt automatically to light/dark mode
- Override styles with copyWith() when you need slight variations (e.g., color)

❌ **DON'T:**
- Mix multiple font sizes without semantic purpose
- Create custom TextStyle() instances in UI code
- Hardcode fontSize values
- Use bodySmall for important primary text
- Create duplicate styles when they already exist in the hierarchy

---

## **Size Hierarchy Summary**

| Component | Primary Size | Secondary Size | Tertiary Size |
|-----------|--------------|----------------|---------------|
| Main Title | headlineLarge (48px) | headlineMedium (40px) | headlineSmall (32px) |
| Section Header | titleLarge (24px) | titleMedium (20px) | titleSmall (18px) |
| Body Content | bodyLarge (18px) | bodyMedium (16px) | bodySmall (14px) |
| Labels/Tags | labelLarge (18px) | labelMedium (16px) | labelSmall (14px) |

---

## **Migration from Manual Styles**

### Before ❌
```dart
Text(
  'Hello',
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
);
```

### After ✅
```dart
Text(
  'Hello',
  style: context.textTheme.bodyMedium,
);
```

---

## **Complete Text Style List**

### Standard Flutter TextTheme
```dart
// Display Styles
context.textTheme.displayLarge, displayMedium, displaySmall

// Headline Styles (Bold)
context.textTheme.headlineLarge    // 48px, w700
context.textTheme.headlineMedium   // 40px, w700
context.textTheme.headlineSmall    // 32px, w700

// Title Styles (Bold)
context.textTheme.titleLarge       // 24px, w700
context.textTheme.titleMedium      // 20px, w700
context.textTheme.titleSmall       // 18px, w700

// Body Styles (Regular)
context.textTheme.bodyLarge        // 18px, w400
context.textTheme.bodyMedium       // 16px, w400
context.textTheme.bodySmall        // 14px, w400

// Label Styles (Regular)
context.textTheme.labelLarge       // 18px, w400
context.textTheme.labelMedium      // 16px, w400
context.textTheme.labelSmall       // 14px, w400
```

### Custom Heading Styles (Shortcuts)
```dart
// All Bold (w700)
context.textTheme.h1    // 48px
context.textTheme.h2    // 40px
context.textTheme.h3    // 32px
context.textTheme.h4    // 24px
context.textTheme.h5    // 20px
context.textTheme.h6    // 18px
```

### Custom Body Styles with Weight Variants
```dart
// Body Large (18px)
context.textTheme.bodyLargeBold       // w700
context.textTheme.bodyLargeMedium     // w500
context.textTheme.bodyLargeRegular    // w400

// Body Medium (16px)
context.textTheme.bodyMediumBold      // w700
context.textTheme.bodyMediumMedium    // w500
context.textTheme.bodyMediumRegular   // w400

// Body Small (14px)
context.textTheme.bodySmallBold       // w700
context.textTheme.bodySmallMedium     // w500
context.textTheme.bodySmallRegular    // w400

// Body Very Small (12px)
context.textTheme.bodyVerySmallRegular // w400
```

---

## **Customizing Text Styles with copyWith()**

When you need to override a style (e.g., change color, add decoration):

```dart
// Change color
Text(
  'Important',
  style: context.textTheme.bodyMedium?.copyWith(
    color: Colors.red,
  ),
);

// Add decoration
Text(
  'Underline text',
  style: context.textTheme.bodyMedium?.copyWith(
    decoration: TextDecoration.underline,
  ),
);

// Combine multiple overrides
Text(
  'Custom style',
  style: context.textTheme.bodyMedium?.copyWith(
    color: context.colors.primary,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.5,
  ),
);
```

Use copyWith() sparingly - prefer using the existing style hierarchy when possible.
