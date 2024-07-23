// generated from rosidl_generator_cpp/resource/idl__traits.hpp.em
// with input from image_transport_tutorials:msg/ResizedImage.idl
// generated code does not contain a copyright notice

#ifndef IMAGE_TRANSPORT_TUTORIALS__MSG__DETAIL__RESIZED_IMAGE__TRAITS_HPP_
#define IMAGE_TRANSPORT_TUTORIALS__MSG__DETAIL__RESIZED_IMAGE__TRAITS_HPP_

#include <stdint.h>

#include <sstream>
#include <string>
#include <type_traits>

#include "image_transport_tutorials/msg/detail/resized_image__struct.hpp"
#include "rosidl_runtime_cpp/traits.hpp"

// Include directives for member types
// Member 'image'
#include "sensor_msgs/msg/detail/image__traits.hpp"

namespace image_transport_tutorials
{

namespace msg
{

inline void to_flow_style_yaml(
  const ResizedImage & msg,
  std::ostream & out)
{
  out << "{";
  // member: original_height
  {
    out << "original_height: ";
    rosidl_generator_traits::value_to_yaml(msg.original_height, out);
    out << ", ";
  }

  // member: original_width
  {
    out << "original_width: ";
    rosidl_generator_traits::value_to_yaml(msg.original_width, out);
    out << ", ";
  }

  // member: image
  {
    out << "image: ";
    to_flow_style_yaml(msg.image, out);
  }
  out << "}";
}  // NOLINT(readability/fn_size)

inline void to_block_style_yaml(
  const ResizedImage & msg,
  std::ostream & out, size_t indentation = 0)
{
  // member: original_height
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "original_height: ";
    rosidl_generator_traits::value_to_yaml(msg.original_height, out);
    out << "\n";
  }

  // member: original_width
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "original_width: ";
    rosidl_generator_traits::value_to_yaml(msg.original_width, out);
    out << "\n";
  }

  // member: image
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "image:\n";
    to_block_style_yaml(msg.image, out, indentation + 2);
  }
}  // NOLINT(readability/fn_size)

inline std::string to_yaml(const ResizedImage & msg, bool use_flow_style = false)
{
  std::ostringstream out;
  if (use_flow_style) {
    to_flow_style_yaml(msg, out);
  } else {
    to_block_style_yaml(msg, out);
  }
  return out.str();
}

}  // namespace msg

}  // namespace image_transport_tutorials

namespace rosidl_generator_traits
{

[[deprecated("use image_transport_tutorials::msg::to_block_style_yaml() instead")]]
inline void to_yaml(
  const image_transport_tutorials::msg::ResizedImage & msg,
  std::ostream & out, size_t indentation = 0)
{
  image_transport_tutorials::msg::to_block_style_yaml(msg, out, indentation);
}

[[deprecated("use image_transport_tutorials::msg::to_yaml() instead")]]
inline std::string to_yaml(const image_transport_tutorials::msg::ResizedImage & msg)
{
  return image_transport_tutorials::msg::to_yaml(msg);
}

template<>
inline const char * data_type<image_transport_tutorials::msg::ResizedImage>()
{
  return "image_transport_tutorials::msg::ResizedImage";
}

template<>
inline const char * name<image_transport_tutorials::msg::ResizedImage>()
{
  return "image_transport_tutorials/msg/ResizedImage";
}

template<>
struct has_fixed_size<image_transport_tutorials::msg::ResizedImage>
  : std::integral_constant<bool, has_fixed_size<sensor_msgs::msg::Image>::value> {};

template<>
struct has_bounded_size<image_transport_tutorials::msg::ResizedImage>
  : std::integral_constant<bool, has_bounded_size<sensor_msgs::msg::Image>::value> {};

template<>
struct is_message<image_transport_tutorials::msg::ResizedImage>
  : std::true_type {};

}  // namespace rosidl_generator_traits

#endif  // IMAGE_TRANSPORT_TUTORIALS__MSG__DETAIL__RESIZED_IMAGE__TRAITS_HPP_
