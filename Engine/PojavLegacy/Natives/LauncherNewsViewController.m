// Blockside dashboard redesign for PojavLauncher iOS v2.2.
// Copyright notices and GPL-3.0 terms are preserved in the engine directory.
#import "LauncherNewsViewController.h"
#import "authenticator/BaseAuthenticator.h"
#import "LauncherMenuViewController.h"
#import "LauncherNavigationController.h"
#import "LauncherPreferences.h"
#import "utils.h"

#include <stdlib.h>

#define sidebarNavController ((UINavigationController *)self.splitViewController.viewControllers[0])
#define sidebarViewController ((LauncherMenuViewController *)sidebarNavController.viewControllers[0])
#define gameNavigationController ((LauncherNavigationController *)self.navigationController)

@interface LauncherNewsViewController ()
@property(nonatomic) UIScrollView *homeScrollView;
@property(nonatomic) UIStackView *contentStack;
@property(nonatomic) CAGradientLayer *heroGradient;
@property(nonatomic) UILabel *versionValueLabel;
@property(nonatomic) UILabel *profileValueLabel;
@property(nonatomic) UILabel *worldsValueLabel;
@property(nonatomic) UILabel *downloadValueLabel;
@property(nonatomic) UIProgressView *downloadProgressView;
@property(nonatomic) NSTimer *refreshTimer;
@end

@implementation LauncherNewsViewController

- (NSString *)imageName { return @"MenuNews"; }

- (BOOL)usesDarkPalette {
    if (@available(iOS 13.0, *)) {
        return self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
    }
    return NO;
}

- (UIColor *)pageColor {
    return [self usesDarkPalette] ? [UIColor colorWithRed:0.055 green:0.075 blue:0.07 alpha:1] : [UIColor colorWithRed:0.94 green:0.95 blue:0.93 alpha:1];
}

- (UIColor *)cardColor {
    return [self usesDarkPalette] ? [UIColor colorWithRed:0.11 green:0.15 blue:0.13 alpha:1] : UIColor.whiteColor;
}

- (UIColor *)primaryTextColor {
    return [self usesDarkPalette] ? [UIColor colorWithWhite:0.96 alpha:1] : [UIColor colorWithRed:0.12 green:0.17 blue:0.14 alpha:1];
}

- (UIColor *)secondaryTextColor {
    return [self usesDarkPalette] ? [UIColor colorWithWhite:0.72 alpha:1] : [UIColor colorWithRed:0.37 green:0.43 blue:0.39 alpha:1];
}

- (UIColor *)accentColor {
    return [UIColor colorWithRed:0.30 green:0.67 blue:0.38 alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    self.view.backgroundColor = [self pageColor];
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.rightBarButtonItem = [sidebarViewController drawAccountButton];
    self.navigationItem.leftItemsSupplementBackButton = YES;

    UILabel *brand = [[UILabel alloc] initWithFrame:CGRectZero];
    brand.text = @"BLOCKSIDE";
    brand.font = [UIFont systemFontOfSize:15 weight:UIFontWeightHeavy];
    brand.textColor = [self primaryTextColor];
    [brand sizeToFit];
    self.navigationItem.titleView = brand;

    [self buildDashboard];
    [self refreshDashboard];
}

- (void)buildDashboard {
    self.homeScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.homeScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.homeScrollView.alwaysBounceVertical = YES;
    self.homeScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.homeScrollView];

    self.contentStack = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 16;
    [self.homeScrollView addSubview:self.contentStack];

    NSLayoutConstraint *preferredWidth = [self.contentStack.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:-36];
    preferredWidth.priority = UILayoutPriorityDefaultHigh;
    [NSLayoutConstraint activateConstraints:@[
        [self.homeScrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.homeScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.homeScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.homeScrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.contentStack.topAnchor constraintEqualToAnchor:self.homeScrollView.topAnchor constant:18],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.homeScrollView.bottomAnchor constant:-26],
        [self.contentStack.centerXAnchor constraintEqualToAnchor:self.homeScrollView.centerXAnchor],
        [self.contentStack.widthAnchor constraintLessThanOrEqualToConstant:700],
        preferredWidth
    ]];

    [self.contentStack addArrangedSubview:[self makeHeroCard]];
    [self.contentStack addArrangedSubview:[self makeVersionCard]];
    [self.contentStack addArrangedSubview:[self makeProfileCard]];
    [self.contentStack addArrangedSubview:[self makeActivityCard]];
    [self.contentStack addArrangedSubview:[self makeWorldsCard]];
    [self.contentStack addArrangedSubview:[self makeFooterCard]];
}

- (UIView *)makeHeroCard {
    UIView *hero = [[UIView alloc] initWithFrame:CGRectZero];
    hero.translatesAutoresizingMaskIntoConstraints = NO;
    hero.layer.cornerRadius = 24;
    hero.layer.masksToBounds = YES;
    [hero.heightAnchor constraintGreaterThanOrEqualToConstant:285].active = YES;

    self.heroGradient = [CAGradientLayer layer];
    self.heroGradient.colors = @[(id)[UIColor colorWithRed:0.19 green:0.49 blue:0.27 alpha:1].CGColor,
                                 (id)[UIColor colorWithRed:0.08 green:0.22 blue:0.16 alpha:1].CGColor];
    self.heroGradient.startPoint = CGPointMake(0, 0);
    self.heroGradient.endPoint = CGPointMake(1, 1);
    [hero.layer insertSublayer:self.heroGradient atIndex:0];

    UILabel *eyebrow = [self label:@"MINECRAFT  •  JAVA EDITION" size:12 weight:UIFontWeightBold color:[UIColor colorWithWhite:0.90 alpha:1]];
    eyebrow.accessibilityTraits = UIAccessibilityTraitHeader;
    UILabel *title = [self label:@"Make this world yours." size:30 weight:UIFontWeightBold color:UIColor.whiteColor];
    title.numberOfLines = 0;
    UILabel *description = [self label:@"Your Java worlds, versions, and controls in one place." size:15 weight:UIFontWeightRegular color:[UIColor colorWithWhite:0.90 alpha:1]];
    description.numberOfLines = 0;

    UIButton *play = [self button:@"PLAY JAVA EDITION" background:[UIColor colorWithRed:0.31 green:0.70 blue:0.40 alpha:1] foreground:UIColor.whiteColor];
    [play addTarget:self action:@selector(playJavaEdition) forControlEvents:UIControlEventTouchUpInside];
    play.accessibilityHint = @"Launches the selected Minecraft Java Edition version";

    UIStackView *items = [[UIStackView alloc] initWithArrangedSubviews:@[eyebrow, title, description, play]];
    items.translatesAutoresizingMaskIntoConstraints = NO;
    items.axis = UILayoutConstraintAxisVertical;
    items.spacing = 12;
    [hero addSubview:items];
    [NSLayoutConstraint activateConstraints:@[
        [items.leadingAnchor constraintEqualToAnchor:hero.leadingAnchor constant:22],
        [items.trailingAnchor constraintEqualToAnchor:hero.trailingAnchor constant:-22],
        [items.topAnchor constraintEqualToAnchor:hero.topAnchor constant:22],
        [items.bottomAnchor constraintEqualToAnchor:hero.bottomAnchor constant:-22]
    ]];
    return hero;
}

- (UIView *)makeVersionCard {
    UIView *card = [self cardWithTitle:@"GAME VERSION" subtitle:@"Choose an installed version or browse releases." icon:@"◈"];
    self.versionValueLabel = [self label:@"Choose a version" size:21 weight:UIFontWeightSemibold color:[self primaryTextColor]];
    UIButton *choose = [self button:@"CHOOSE VERSION  ›" background:[self accentColor] foreground:UIColor.whiteColor];
    [choose addTarget:self action:@selector(chooseVersion) forControlEvents:UIControlEventTouchUpInside];
    UIStackView *items = [[UIStackView alloc] initWithArrangedSubviews:@[self.versionValueLabel, choose]];
    items.translatesAutoresizingMaskIntoConstraints = NO;
    items.axis = UILayoutConstraintAxisVertical;
    items.spacing = 12;
    [card addSubview:items];
    [NSLayoutConstraint activateConstraints:@[
        [items.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18],
        [items.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18],
        [items.topAnchor constraintEqualToAnchor:card.topAnchor constant:74],
        [items.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-18]
    ]];
    return card;
}

- (UIView *)makeProfileCard {
    UIView *card = [self cardWithTitle:@"PLAYER" subtitle:@"Official Microsoft sign-in is handled by the Java launcher." icon:@"●"];
    self.profileValueLabel = [self label:@"No account selected" size:17 weight:UIFontWeightSemibold color:[self primaryTextColor]];
    UIButton *account = [self button:@"ACCOUNT OPTIONS  ›" background:[self cardColor] foreground:[self accentColor]];
    account.layer.borderWidth = 1;
    account.layer.borderColor = [self accentColor].CGColor;
    [account addTarget:self action:@selector(openAccountPicker) forControlEvents:UIControlEventTouchUpInside];
    UIStackView *items = [[UIStackView alloc] initWithArrangedSubviews:@[self.profileValueLabel, account]];
    items.translatesAutoresizingMaskIntoConstraints = NO;
    items.axis = UILayoutConstraintAxisVertical;
    items.spacing = 12;
    [card addSubview:items];
    [NSLayoutConstraint activateConstraints:@[
        [items.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18],
        [items.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18],
        [items.topAnchor constraintEqualToAnchor:card.topAnchor constant:76],
        [items.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-18]
    ]];
    return card;
}

- (UIView *)makeActivityCard {
    UIView *card = [self cardWithTitle:@"DOWNLOAD ACTIVITY" subtitle:@"Version and library downloads run through the Java engine." icon:@"↓"];
    self.downloadValueLabel = [self label:@"Ready" size:14 weight:UIFontWeightMedium color:[self secondaryTextColor]];
    self.downloadProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.downloadProgressView.progressTintColor = [self accentColor];
    self.downloadProgressView.trackTintColor = [self pageColor];
    UIStackView *items = [[UIStackView alloc] initWithArrangedSubviews:@[self.downloadValueLabel, self.downloadProgressView]];
    items.translatesAutoresizingMaskIntoConstraints = NO;
    items.axis = UILayoutConstraintAxisVertical;
    items.spacing = 10;
    [card addSubview:items];
    [NSLayoutConstraint activateConstraints:@[
        [items.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18],
        [items.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18],
        [items.topAnchor constraintEqualToAnchor:card.topAnchor constant:76],
        [items.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-20]
    ]];
    return card;
}

- (UIView *)makeWorldsCard {
    UIView *card = [self cardWithTitle:@"RECENT WORLDS" subtitle:@"Saved worlds in the active game directory." icon:@"▦"];
    self.worldsValueLabel = [self label:@"No local worlds yet" size:15 weight:UIFontWeightMedium color:[self primaryTextColor]];
    self.worldsValueLabel.numberOfLines = 0;
    UIStackView *items = [[UIStackView alloc] initWithArrangedSubviews:@[self.worldsValueLabel]];
    items.translatesAutoresizingMaskIntoConstraints = NO;
    items.axis = UILayoutConstraintAxisVertical;
    items.spacing = 10;
    [card addSubview:items];
    [NSLayoutConstraint activateConstraints:@[
        [items.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18],
        [items.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18],
        [items.topAnchor constraintEqualToAnchor:card.topAnchor constant:76],
        [items.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-18]
    ]];
    return card;
}

- (UIView *)makeFooterCard {
    UIView *card = [self cardWithTitle:@"ENGINE STATUS" subtitle:@"Real Java Edition runtime · ARM64 · iOS 12.2+" icon:@"✓"];
    UILabel *status = [self label:@"Minecraft files are fetched from official services after sign-in. A compatible JIT setup is required for usable game performance." size:13 weight:UIFontWeightRegular color:[self secondaryTextColor]];
    status.numberOfLines = 0;
    UIStackView *items = [[UIStackView alloc] initWithArrangedSubviews:@[status]];
    items.translatesAutoresizingMaskIntoConstraints = NO;
    items.axis = UILayoutConstraintAxisVertical;
    [card addSubview:items];
    [NSLayoutConstraint activateConstraints:@[
        [items.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18],
        [items.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18],
        [items.topAnchor constraintEqualToAnchor:card.topAnchor constant:76],
        [items.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-18]
    ]];
    return card;
}

- (UIView *)cardWithTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(NSString *)icon {
    UIView *card = [[UIView alloc] initWithFrame:CGRectZero];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [self cardColor];
    card.layer.cornerRadius = 20;
    card.layer.masksToBounds = YES;
    [card.heightAnchor constraintGreaterThanOrEqualToConstant:140].active = YES;

    UILabel *mark = [self label:icon size:18 weight:UIFontWeightBold color:[self accentColor]];
    mark.textAlignment = NSTextAlignmentCenter;
    mark.backgroundColor = [self pageColor];
    mark.layer.cornerRadius = 16;
    mark.layer.masksToBounds = YES;
    [mark.widthAnchor constraintEqualToConstant:34].active = YES;
    [mark.heightAnchor constraintEqualToConstant:34].active = YES;

    UILabel *heading = [self label:title size:11 weight:UIFontWeightBold color:[self secondaryTextColor]];
    UILabel *caption = [self label:subtitle size:13 weight:UIFontWeightRegular color:[self secondaryTextColor]];
    caption.numberOfLines = 0;
    UIStackView *titles = [[UIStackView alloc] initWithArrangedSubviews:@[heading, caption]];
    titles.axis = UILayoutConstraintAxisVertical;
    titles.spacing = 4;
    UIStackView *header = [[UIStackView alloc] initWithArrangedSubviews:@[mark, titles]];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    header.axis = UILayoutConstraintAxisHorizontal;
    header.alignment = UIStackViewAlignmentTop;
    header.spacing = 12;
    [card addSubview:header];
    [NSLayoutConstraint activateConstraints:@[
        [header.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18],
        [header.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18],
        [header.topAnchor constraintEqualToAnchor:card.topAnchor constant:18]
    ]];
    return card;
}

- (UILabel *)label:(NSString *)text size:(CGFloat)size weight:(UIFontWeight)weight color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    return label;
}

- (UIButton *)button:(NSString *)title background:(UIColor *)background foreground:(UIColor *)foreground {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:foreground forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    button.backgroundColor = background;
    button.layer.cornerRadius = 14;
    button.contentEdgeInsets = UIEdgeInsetsMake(15, 16, 15, 16);
    button.heightAnchor.constraint(greaterThanOrEqualToConstant:50).active = YES;
    return button;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.heroGradient.frame = self.contentStack.arrangedSubviews.firstObject.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshDashboard];
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDashboardTick:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    self.view.backgroundColor = [self pageColor];
    [self.contentStack.arrangedSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (idx > 0) view.backgroundColor = [self cardColor];
    }];
    [self refreshDashboard];
}

- (void)refreshDashboard {
    self.versionValueLabel.text = [gameNavigationController selectedVersionIdentifier];
    NSDictionary *account = BaseAuthenticator.current.authData;
    NSString *username = account[@"username"];
    self.profileValueLabel.text = username.length > 0 ? username : @"Sign in with Microsoft or choose demo mode";

    NSString *activity = gameNavigationController.progressText.text;
    self.downloadValueLabel.text = activity.length > 0 ? activity : @"Ready — choose a version to install or play";
    float progress = gameNavigationController.progressViewMain.progress;
    if (progress <= 0.0f && gameNavigationController.progressViewMain.observedProgress != nil) {
        progress = gameNavigationController.progressViewMain.observedProgress.fractionCompleted;
    }
    self.downloadProgressView.progress = MAX(0.0f, MIN(1.0f, progress));

    const char *gameDirectory = getenv("POJAV_GAME_DIR");
    NSString *savesPath = gameDirectory ? [[NSString stringWithUTF8String:gameDirectory] stringByAppendingPathComponent:@"saves"] : nil;
    NSArray<NSString *> *worldNames = savesPath ? [[NSFileManager defaultManager] contentsOfDirectoryAtPath:savesPath error:nil] : nil;
    NSMutableArray<NSString *> *directories = NSMutableArray.array;
    for (NSString *name in worldNames) {
        NSString *path = [savesPath stringByAppendingPathComponent:name];
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) [directories addObject:name];
        if (directories.count == 3) break;
    }
    self.worldsValueLabel.text = directories.count > 0 ? [directories componentsJoinedByString:@"\n"] : @"No local worlds yet. Worlds created in Java Edition appear here.";
}

- (void)refreshDashboardTick:(NSTimer *)timer {
    [self refreshDashboard];
}

- (void)playJavaEdition {
    [gameNavigationController launchSelectedVersion];
}

- (void)chooseVersion {
    [gameNavigationController showVersionSelector];
}

- (void)openAccountPicker {
    [sidebarViewController selectAccount:sidebarViewController.accountButton];
}

@end
