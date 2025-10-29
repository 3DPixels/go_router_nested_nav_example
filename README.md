# go_router_nested_nav_example

A nested navigation with go router and animations that implements the following requirements:

1. It will have a main page containing an appBar with a drawer, the drawer has 3 pages to navigate with: a, b, c.

2. a, b, and c pages have a button, I can tap on the button to navigate into the tab details while staying in the main page (meaning nested navigation).

3. Going back from the details page will always go back to its parent page (doesn't exit the main page).

4. Going back from any page other than 'a' will change the mainPage body to 'a'.

5. Going back in 'a' will show a dialog for exiting the app.

6. 'a' page has an extra button, tapping on that will navigate me to b/details in 'b' tab (still inside MainPage), trying to go back from there will make me go back to its parent 'b' page, not 'a' page.

7. Do not save the state of any page, meaning if I went to c page, for exampl,e and went inside details then tapped on the 'a' page, then went back to 'c' page, I should be in the 'c' page, not the details page.

8. Every tab switch should use the animation package PageTransitionSwitcher to make use of the Material animations switch.

9. Every tab-to-details transition should use the Cupertino transition animation (which looks like a slide animation with a slight parallax effect)
