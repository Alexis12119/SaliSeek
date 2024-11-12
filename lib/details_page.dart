import 'package:SaliSeek/submitted_file.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<SubmittedFile> submittedFiles = [];
  final bool _isUploading = false;
  final supabase = Supabase.instance.client;

  String? dueDate;
  String? description;

  @override
  void initState() {
    super.initState();
    fetchTaskData();
  }

  // Fetch task data from Supabase
  Future<void> fetchTaskData() async {
    final response = await supabase
        .from('tasks')
        .select('due_date, description')
        .eq('id', 1)
        .single();

    setState(() {
      dueDate = response['due_date'];
      description = response['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildHeader(context),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date: ${dueDate ?? "Loading..."}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: Colors.red, size: 20.0),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Submit before the due date to avoid penalties.',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const Text(
                        'Task Description',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        description ?? 'Loading...',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 24.0),
                      // File Upload Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Your Submission',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              if (submittedFiles.isNotEmpty)
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      submittedFiles.clear();
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline,
                                      size: 20),
                                  label: const Text('Clear all'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          InkWell(
                            onTap: _isUploading ? null : _handleFileUpload,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 48.0,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(height: 12.0),
                                  Text(
                                    _isUploading
                                        ? 'Uploading...'
                                        : 'Click to upload your file',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Supported formats: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // Display uploaded files
                          ...submittedFiles.map((file) => _buildFileItem(file)),
                          if (submittedFiles.isNotEmpty) ...[
                            const SizedBox(height: 24.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Assignment submitted successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C9B44),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Submit Assignment',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFFF2F8FC),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(SubmittedFile file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(_getFileIcon(file.fileType),
              color: _getFileColor(file.fileType), size: 24.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.fileName,
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Uploaded ${_formatDate(file.uploadTime)} • ${file.fileSize}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              setState(() {
                submittedFiles.remove(file);
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleFileUpload() async {
    // Open file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Get the selected file's properties
      String fileName = result.files.single.name;
      String fileSize =
          '${(result.files.single.size / 1024).toStringAsFixed(2)} KB'; // Size in KB
      String fileType = result.files.single.extension ?? 'unknown';

      // Add the file to the submitted files list
      setState(() {
        submittedFiles.add(
          SubmittedFile(
            fileName: fileName,
            fileSize: fileSize,
            uploadTime: DateTime.now(),
            fileType: fileType,
          ),
        );
      });

      // Show success message if the widget is still mounted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File selected successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 10.0 : 18.0;
    double subtitleFontSize =
        screenWidth < 600 ? 9.0 : 12.0; // Subtitle font size
    double padding = screenWidth < 600 ? 12.0 : 16.0;
    double iconSize = screenWidth < 600 ? 15.0 : 20.0;
    double iconPadding = screenWidth < 600 ? 0.0 : 8.0;
    double logoSize = screenWidth < 600 ? 20.0 : 30.0;

    return Container(
      color: const Color(0xFF2C9B44),
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(iconPadding),
            child: IconButton(
              iconSize: iconSize,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(width: screenWidth < 600 ? 2.0 : 6.0),

          // Logo
          CircleAvatar(
            radius: logoSize,
            backgroundColor: const Color(0xFFF2F8FC),
            backgroundImage: const AssetImage('assets/images/plsp.jpg'),
          ),

          const SizedBox(width: 8.0),

          // Column for Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pamantasan ng Lungsod ng San Pablo',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0), // Space between title and subtitle

                // Subtitle details
                Text(
                  'Brgy. San Jose, San Pablo City',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: const Color(0xFFF2F8FC),
                  ),
                ),
                Text(
                  'Tel No: (049) 536-7380',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: const Color(0xFFF2F8FC),
                  ),
                ),
                Text(
                  'Email Address: plspofficial@plsp.edu.ph',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: const Color(0xFFF2F8FC),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
