import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String value)? onSearch;

  const SearchBarWidget({
    super.key,
    this.onSearch,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style:  TextStyle(color: Colors.white),
              textInputAction: TextInputAction.search, // shows Search/Done
              cursorColor: Colors.white,

              decoration:  InputDecoration(
                
                hintText: "Search nearby charging station",
                hintStyle: TextStyle(color: CommonColors.background,fontSize: 13),
                border: InputBorder.none,
                
                suffixIcon: _controller.text.isNotEmpty
    ? IconButton(
        icon: Icon(Icons.clear, color: Colors.white),
        onPressed: () {
           FocusManager.instance.primaryFocus?.unfocus();
          _controller.clear();
          setState(() {});
        },
      )
    : null,
              ),

              onSubmitted: (value) {
                if (value.trim().isEmpty) return;

                // 🔍 Trigger search
                widget.onSearch?.call(value.trim());

                // Optional: close keyboard
                _focusNode.unfocus();
              },
              
            ),
          ),
        ],
      ),
    );
  }
}

// class SearchBarWidget extends StatelessWidget {
//   const SearchBarWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: const Row(
//         children: [
//           Icon(Icons.search, color: Colors.white),
//           SizedBox(width: 10),
//           Expanded(
//             child: TextField(
//               style: TextStyle(color: CommonColors.white),
//               decoration: InputDecoration(
//                 hintStyle: TextStyle(color: CommonColors.background),
//                 hintText: "Search nearby charging station",
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
