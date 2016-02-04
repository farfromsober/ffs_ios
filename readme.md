# 4sale! - iOS Client
---
Final Group Project

KeepCoding Startup Engineering Bootcamp

---

## Project structure:

Summary:

- **Application** - *Global classes related with app configuration, constants, settings, delegates...*

- **Controllers** - *All the viewControllers and their XIBs.*

- **Managers** - *Singletons, Classes to handle logic or operation... Example: KeyboardManager, UserManager, APIManager, etc.*

- **Models** - *Model Objects of the app.*

- **Resources** - *Assets, LaunchScreen, and other files added into the bundle.*

- **Utils** - *Categories, adapters, etc*

- **Views** - *Custom subviews*

	NOTE: Don't create massive ViewControllers. Use Managers and Utils classes. VCs should only handle view events and dispatch actions.
	

### Application

- AppConstants: just a place where define all the constants used in the app.
- AppDelegate: here, during `didFinishLaunchingWithOptions` we are assigning a tabBarController as rootViewController of *self.window*.
- AppNavigation: all the navigation of the app should handle through this class. You can also use this class to initialize your VC before pushing or presenting it (for instance, we are initializing the TabBarController here). This way all your ViewControllers imports are located in one place.

		// how to use it
		[AppNavigation pushDetailViewControllerWithNavigationHandler:(UINavigationController *)navController];
	
		// the definition of the method in AppNavigation.m
		#import "DetailViewController.h"
		
		+ (void)pushDetailViewControllerWithNavigationHandler:(UINavigationController *)navController {
			DetailViewController *destination = [DetailViewController new];
			navController pushViewController:destination withAnimation:YES];
		}
		
- AppStyle: views' elements should be styled here.

### Controllers

- TabController contains 5 Tabs: *ProductsVC, MapVC, NotificationVC, and ProfileVC*. All these classes have a superclass called BaseVC and they are embedded in a Navigation Controller to support push navigation.
- LoginViewController: login screen.
- NewVC: post a new product.

### Managers

- User Manager: a Singleton class to manage *currentUser* Object. You can create, update and reset the *currentUser*. This property is readonly and his information is stored in the Documents folder of the bundle. For now, it is not encrypted.
- APIManager: another Singleton to manage the AFNetworking session manager. All API calls should be defined here, not in the ViewControllers.

### Models

- User
- Product
- ProductCategory
- SavedSearch
- Transaction

All the Model objects conforms two protocols: *JSONCreator* and *JSONParser*. The first one is to create a NSDictionary from an object, meanwhile the second one parse an nsdictionary into an object. In all the class we have added some defense code to avoid problems. We also have created some unit tests.

In order to persist User object, we are implementing encode and decode methods.

### Utils

For now, same useful categories to extend some Cocoa Touch classes: NSString, NSArray, etc.

### Views

Any subview have been created yet.



