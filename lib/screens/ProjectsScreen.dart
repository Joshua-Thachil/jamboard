import 'package:flutter/material.dart';
import 'package:jamboard/Style/Palette.dart';
import 'package:jamboard/components/InputFields.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {

  final List<String> _projectList = [
    "Indian OC 1",
    "Faint",
    "Strawberry pulp - version 1"
  ]; //the main list of projects for backend
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredProjectList = [];

  @override
  void initState() {
    super.initState();
    _filteredProjectList = _projectList; // Initialize the filtered list with the full project list
  }

  // Function to filter the project list based on search input
  void _filterProjects(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProjectList = _projectList;
      } else {
        _filteredProjectList = _projectList
            .where((project) => project.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  //function to open a popUp
  Future<void> _showInputDialog(BuildContext context) async {
    TextEditingController _projectnamecontroller = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shadowColor: Colors.black,
          elevation: 10.0,
          backgroundColor: Color(0xff131313),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity, // Make the container take the maximum width
            padding: EdgeInsets.all(20), // Add padding if needed
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use minimum size for dialog
              children: [
                Text(
                  'Add a new Project',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30), // Add space between title and input field
                InputField(
                  InputController: _projectnamecontroller,
                  height: 1,
                  hint: 'Enter project title',
                  bgcolor: Palette.secondary_bg,
                ),
                SizedBox(height: 20), // Add space between input and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('Cancel', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    SizedBox(width: 10), // Add space between buttons
                    TextButton(
                      child: Text('Submit', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          _projectList.add(_projectnamecontroller.text);
                        });
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            // Animated Title and Search Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align the row's children to the right
              children: [
                // Conditionally display either title or search bar based on search activity
                Expanded(
                  child: Stack(
                    // alignment: Alignment.centerRight, // Align the search bar to the right
                    children: [
                      // Search bar animation (grows from right to left)
                      Container(
                        padding: EdgeInsets.only(top: 8),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: _isSearchActive
                              ? MediaQuery.of(context).size.width - 90
                              : 0, // Starts at 0 width and expands
                          child: _isSearchActive
                              ? TextField(
                            onChanged: _filterProjects,
                            controller: _searchController,
                            autofocus: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search project',
                              hintStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Palette.secondary_bg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          )
                              : SizedBox.shrink(), // Hide search bar when inactive
                        ),
                      ),
                      // Title and subtitle animation (shown when search is inactive)
                      AnimatedOpacity(
                        opacity: _isSearchActive ? 0 : 1,
                        duration: Duration(milliseconds: 100),
                        child: Column(
                          key: ValueKey("titleText"),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello Arlene !",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            const Text(
                              "What are we working on today?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Search/close icon
                IconButton(
                  icon: Icon(
                    _isSearchActive ? Icons.close : Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isSearchActive) {
                        // Clear the search controller
                        _searchController.clear();
                        // Reset the filtered project list
                        _filteredProjectList = _projectList; // Reset to show all projects
                      }
                      // Toggle the search state
                      _isSearchActive = !_isSearchActive;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            Expanded(
              child: _filteredProjectList.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/images/rb_2150544943.png', // Path to your no projects image
                    //   width: 200, // Set width for the image
                    //   height: 200, // Set height for the image
                    // ),
                    SizedBox(height: 20), // Space between image and text
                    Text(
                      'Wanna add a new project?', // Message when no projects
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: _filteredProjectList.length,
                itemBuilder: (context, index) {
                  final project = _filteredProjectList[index];

                  return Dismissible(
                    key: Key(project), // Unique key for each project
                    background: Container(
                      color: Colors.red, // Background color when swiping
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.delete, color: Colors.white), // Delete icon
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        // Remove the project from the original list
                        _projectList.remove(project);

                        // Remove from the filtered list
                        _filteredProjectList.removeAt(index);
                      });

                      // // Optionally, show a snackbar
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text("$project dismissed")),
                      // );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 12),
                      child: TextButton.icon(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 25)),
                          backgroundColor: WidgetStateProperty.all(Palette.secondary_bg),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () {
                          // Define your onPressed action here
                        },
                        icon: Icon(
                          Icons.music_note_outlined,
                          color: Palette.primary,
                          size: 35,
                        ),
                        label: Text(
                          project,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 40),
        child: BottomAppBar(
          color: Palette.bg,
          child: Center(
            child: GestureDetector(
              onTap: () {
                _showInputDialog(context);
              },
              child: Icon(
                Icons.add_circle_rounded,
                color: Palette.primary,
                size: 80,
              ),
            )
          ),
        ),
      ),
    );
  }
}
